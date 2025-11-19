import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadField extends StatefulWidget {
  final int maxImages;
  final List<File> initialImages;
  final ValueChanged<List<File>> onImagesChanged;
  final String? errorText;

  const ImageUploadField({
    super.key,
    this.maxImages = 3,
    this.initialImages = const [],
    required this.onImagesChanged,
    this.errorText,
  });

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _images.addAll(widget.initialImages);
  }

  void _addMessage(String type, String message) {
    setState(() {
      _messages.add({'type': type, 'message': message});
    });
  }

  void _clearMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
  }

  void _clearAllMessages() {
    setState(() {
      _messages.clear();
    });
  }

  Future<bool> _validateFile(File file) async {
    const allowedExtensions = [".jpg", ".jpeg", ".png", ".gif", ".webp", ".svg"];
    const maxFileSize = 25000000; // 25MB
    String fileName = file.path.toLowerCase();

    bool hasValidExtension = allowedExtensions.any((ext) => fileName.endsWith(ext));
    if (!hasValidExtension) {
      _addMessage('error', 'Invalid file type: ${fileName.split('.').last}');
      return false;
    }

    int fileSize = await file.length();
    if (fileSize > maxFileSize) {
      double fileSizeMB = fileSize / (1024 * 1024);
      double maxSizeMB = maxFileSize / (1024 * 1024);
      _addMessage('error',
          'File too large: ${fileSizeMB.toStringAsFixed(1)}MB (Max: ${maxSizeMB.toStringAsFixed(0)}MB)');
      return false;
    }
    return true;
  }

  Future<String> _getFileMD5Hash(File file) async {
    final bytes = await file.readAsBytes();
    return md5.convert(bytes).toString();
  }

  Future<bool> _areFilesDuplicate(File file1, File file2) async {
    if (await file1.length() != await file2.length()) return false;
    return await _getFileMD5Hash(file1) == await _getFileMD5Hash(file2);
  }

  Future<bool> _isFileAlreadySelected(File newFile) async {
    for (File existingFile in _images) {
      if (await _areFilesDuplicate(newFile, existingFile)) {
        return true;
      }
    }
    return false;
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Image Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_camera,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _takePhoto();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImages();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    _clearAllMessages();

    final remaining = widget.maxImages - _images.length;
    if (remaining <= 0) {
      _addMessage('error', 'Maximum ${widget.maxImages} images allowed.');
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo == null) return;

      File newFile = File(photo.path);
      if (!await _validateFile(newFile)) return;

      setState(() {
        _images.add(newFile);
      });
      widget.onImagesChanged(_images);
      _addMessage('success', 'Photo captured and added successfully.');
    } catch (e) {
      _addMessage('error', 'Failed to capture photo: ${e.toString()}');
    }
  }

  Future<void> _pickImages() async {
    _clearAllMessages();

    final remaining = widget.maxImages - _images.length;
    if (remaining <= 0) {
      _addMessage('error', 'Maximum ${widget.maxImages} images allowed.');
      return;
    }

    final picked = await _picker.pickMultiImage();
    if (picked.isEmpty) return;

    List<File> validNewImages = [];
    List<String> duplicateNames = [];

    for (var img in picked) {
      File newFile = File(img.path);
      String newFileName = img.name;

      if (!await _validateFile(newFile)) continue;
      if (await _isFileAlreadySelected(newFile)) {
        duplicateNames.add(newFileName);
      } else {
        validNewImages.add(newFile);
      }
    }

    if (duplicateNames.isNotEmpty) {
      _addMessage('warning', 'Duplicates skipped: ${duplicateNames.join(", ")}');
    }

    if (_images.length + validNewImages.length > widget.maxImages) {
      _addMessage(
          'error',
          'Can only add $remaining more image(s). Selected ${validNewImages.length}.');
      return;
    }

    if (validNewImages.isNotEmpty) {
      setState(() {
        _images.addAll(validNewImages);
      });
      widget.onImagesChanged(_images);
      _addMessage('success', '${validNewImages.length} image(s) added successfully.');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      _clearAllMessages();
    });
    widget.onImagesChanged(_images);
  }

  void _clearAllImages() {
    setState(() {
      _images.clear();
      _clearAllMessages();
    });
    widget.onImagesChanged(_images);
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        errorText: widget.errorText,
        contentPadding: EdgeInsets.all(8),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _images.isEmpty
                ? InkWell(
              onTap: _showImageSourceBottomSheet,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Click to upload images'),
                  Text('(Max 3 images)', style: TextStyle(fontSize: 12)),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: FileImage(_images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: InkWell(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_images.length < widget.maxImages)
                        TextButton.icon(
                          onPressed: _showImageSourceBottomSheet,
                          icon: const Icon(Icons.add),
                          label: const Text('Add More'),
                        ),
                      TextButton.icon(
                        onPressed: _clearAllImages,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear All'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_messages.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...List.generate(_messages.length, (index) {
              final msg = _messages[index];
              final type = msg['type']!;
              final text = msg['message']!;

              Color bg, border, iconColor;
              IconData icon;

              switch (type) {
                case 'error':
                  bg = Colors.red.shade50;
                  border = Colors.red;
                  iconColor = Colors.red;
                  icon = Icons.error;
                  break;
                case 'warning':
                  bg = Colors.orange.shade50;
                  border = Colors.orange;
                  iconColor = Colors.orange;
                  icon = Icons.warning;
                  break;
                default:
                  bg = Colors.green.shade50;
                  border = Colors.green;
                  iconColor = Colors.green;
                  icon = Icons.check_circle;
              }

              return Container(
                margin: EdgeInsets.only(top: index > 0 ? 4 : 0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: border, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: iconColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(text, style: const TextStyle(fontSize: 12)),
                    ),
                    InkWell(
                      onTap: () => _clearMessage(index),
                      child: Icon(Icons.close, size: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }),
          ]
        ],
      ),
    );
  }
}
