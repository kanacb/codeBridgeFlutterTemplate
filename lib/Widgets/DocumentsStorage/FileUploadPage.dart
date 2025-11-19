import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Utils/Dialogs/BuildSvgIcon.dart';
import '../../Utils/Globals.dart' as globals;
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/Services/Response.dart';
import '../../Widgets/DocumentsStorage/UploadFile.dart';
import 'UploaderService.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage(
      {super.key, required this.table, required this.onChange, this.tableId});

  final ValueChanged<String> onChange;
  final String table;
  final String? tableId;

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  Logger logger = globals.logger;
  FilePickerResult? results;
  final UploaderService uploaderService = UploaderService();
  List<Map<String, dynamic>> _selectedFiles = [];
  SnackBars snackBar = SnackBars();
  bool isNew = true;
  bool _isLoading = false;

  Future<void> requestPermissions() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  void _pickFiles(FileType type, List<String> allowedExtensions) async {
    try {
      Navigator.of(context).pop();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowCompression: false,
        type: type,
        allowMultiple: true,
        allowedExtensions: allowedExtensions,
        onFileLoading: (FilePickerStatus status) {
          setState(() {
            _isLoading = status == FilePickerStatus.picking;
          });
        },
      );

      if (result != null) {
        // Extract file paths
        List<Map<String, dynamic>> files = result.files
            .map((file) => {
                  'path': file.path,
                  'name': file.name,
                  'size': file.size.toString(),
                  'checked': false,
                  'file': file,
                  'isImage': _isImage(file.path),
                  'icon': findIcon(file.path)
                })
            .toList();
        setState(() {
          _selectedFiles = files;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking file: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleCheckbox(int index) {
    setState(() {
      _selectedFiles[index]['checked'] = !_selectedFiles[index]['checked'];
    });
  }

  _savePickedFiles() async {
    for (var file in _selectedFiles!) {
      if (file?['checked']) await _pickFile(file);
    }
  }

  Future<void> _pickFile(dynamic file) async {
    /// Load result and file details
    File _file = File(file['path']);
    String contentType = detectMimeType(_file!.path);

    UploadFile uploadFile = UploadFile(
        name: file.name,
        size: file.size.toString(),
        type: file.extension ?? "",
        path: _file.path,
        ext: file.extension ?? "",
        url: _file.uri.path,
        lastModified: _file.lastModifiedSync().millisecondsSinceEpoch,
        lastModifiedDate: _file.lastModifiedSync(),
        tableId: widget.tableId ?? "",
        tableName: widget.table,
        contentType: contentType ?? "");

    await uploadFileRequest(_file, uploadFile);
  }

  // void _pickDirectory() async {
  //   String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  //   if (selectedDirectory != null) {
  //     setState(() {
  //       _fileText = selectedDirectory;
  //     });
  //   } else {
  //     Navigator.of(context).pop();
  //   }
  // }

  Future<void> uploadFileRequest(File? file, UploadFile uploadFile) async {
    if (file == null) {
      if (kDebugMode) {
        print("No file selected!");
      }
      return;
    }

    // try {
    //   // Create a multipart request to send the file
    //   Response response =
    //       await uploaderService.uploadFile(upload: uploadFile, file: file);
    //
    //   if (response.statusCode == 200) {
    //     if (kDebugMode) {
    //       print("File uploaded successfully!");
    //     }
    //   } else {
    //     if (kDebugMode) {
    //       print("Failed to upload file: ${response.error}");
    //     }
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("Error uploading file: $e ${uploadFile.name}");
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _enableButtonOnLoad();
  }

  void _enableButtonOnLoad() {
    // Simulate a delay if needed, or set it immediately
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        buildBottomSheetDialog();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Multi-File Picker"),
          actions: [
            GestureDetector(
              onTap: _selectedFiles.isNotEmpty
                  ? _savePickedFiles
                  : buildBottomSheetDialog,
              child: Text(_selectedFiles.isNotEmpty ? "save" : "browse"),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading files, please wait...'),
                ],
              )
            else if (_selectedFiles.isNotEmpty)
              buildSelectedFilesDialog()
            else
              Center(
                child: ElevatedButton(
                  autofocus: true,
                  onPressed: buildBottomSheetDialog,
                  child: Text('Browse Files'),
                ),
              )
          ],
        ));
  }

  buildSelectedFilesDialog() {
    return Expanded(
      child: ListView.builder(
          itemCount: _selectedFiles.length,
          itemBuilder: (context, index) {
            final file = _selectedFiles[index];
            return CheckboxListTile(
              activeColor: Colors.grey,
              title: Text(_selectedFiles[index]['name'] ?? 'Unknown'),
              subtitle: Row(
                children: [
                  Text("size: "),
                  Text(_selectedFiles[index]['size'] ?? 'undefined'),
                  Text(_selectedFiles[index]['size'] == null ? "" : " Mb"),
                ],
              ),
              value: _selectedFiles[index]['checked'],
              onChanged: (bool? value) {
                _toggleCheckbox(index);
              },
              secondary: file['isImage'] && file['path'] != null
                  ? Image.file(
                      File(file['path']),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : file['icon'],
            );
          }),
    );
  }

  // ImageIcon(
  // AssetImage('assets/images/iconRandom.png'),
  // size: 30,
  // color: Colors.red,
  // ),

  // IconButton(
  // icon: Icon(
  // icon,
  // size: iconSize,
  // color: iconColor,
  // ),

  buildBottomSheetDialog() {
    showModalBottomSheet(
        sheetAnimationStyle: AnimationStyle(),
        barrierLabel: "selector",
        showDragHandle: true,
        backgroundColor: Colors.white,
        enableDrag: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(
              spacing: 25.0,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.spaceEvenly,
              runSpacing: 24.0,
              children: [
                CircularIconWithTitle(
                    icon: Icons.document_scanner_sharp,
                    iconColor: Colors.red[600]!,
                    title: 'Docs',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () =>
                        _pickFiles(FileType.custom, ['pdf', 'doc', 'txt'])),
                CircularIconWithTitle(
                    icon: Icons.image_rounded,
                    iconColor: Colors.green[600]!,
                    title: 'Images',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () =>
                        _pickFiles(FileType.image, [])),
                CircularIconWithTitle(
                    icon: Icons.camera_alt,
                    iconColor: Colors.yellow[600]!,
                    title: 'Camera',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () => {}),
                CircularIconWithTitle(
                    icon: Icons.audio_file_outlined,
                    iconColor: Colors.purple[600]!,
                    title: 'Audio',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () => _pickFiles(
                        (FileType.audio), [])),
                CircularIconWithTitle(
                    icon: Icons.videocam_outlined,
                    iconColor: Colors.blue[600]!,
                    title: 'Video',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () => _pickFiles(
                        (FileType.video), [])),
                CircularImageWithTitle(
                    imagePath: "assets/images/csv.png",
                    iconColor: Colors.blue[600]!,
                    title: 'csv',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () => _pickFiles((FileType.custom), ['csv'])),
                CircularImageWithTitle(
                    imagePath: "assets/images/zip.png",
                    iconColor: Colors.blue[600]!,
                    title: 'zip',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () => _pickFiles((FileType.custom), ['zip'])),
                CircularImageWithTitle(
                    imagePath: "assets/images/json.png",
                    iconColor: Colors.blue[600]!,
                    title: 'json',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () => _pickFiles((FileType.custom),['json'])),
                CircularImageWithTitle(
                    imagePath: "assets/images/xls.png",
                    iconColor: Colors.blue[600]!,
                    title: 'xlsx',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () => _pickFiles((FileType.custom),['xlsx'])),
                CircularImageWithTitle(
                    imagePath: "assets/images/sql.png",
                    iconColor: Colors.blue[600]!,
                    title: 'sql',
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onPressed: () => _pickFiles((FileType.custom),['sql'])),
              ],
            ),
          );
        });
  }

  // Widget buildCamera() {
  //   return IconButton(
  //     icon: const Icon(Icons.camera_alt),
  //     onPressed: ,
  //   );
  // }

  String detectMimeType(String filePath) {
    try {
      // Detect MIME type based on the file path
      final mimeType = lookupMimeType(filePath);

      if (mimeType == null) {
        return 'Unknown MIME type.';
      }
      // Classify the file based on MIME type
      if (mimeType.startsWith('text/') || mimeType == 'application/json') {
        // Text-based MIME types (handle as String)
        return 'string';
      } else if (mimeType.startsWith('image/') ||
          mimeType.startsWith('video/') ||
          mimeType == 'application/pdf') {
        return "binary";
      } else {
        return "unsupported";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while processing file: $e');
      }
      return "error";
    }
  }

  Widget findIcon(String? path) {
    if (path == null) return Icon(Icons.insert_drive_file_outlined);
    final extension = path.split('.').last.toLowerCase();
    const imageExtensions = ['gif', 'bmp', 'webp', 'svg'];
    const audioExtensions = ['mpeg', 'aac', 'ogg', 'wav', 'webm'];
    const videoExtensions = ['mp4', 'webm', 'ogg', 'mpeg'];
    const dataExtensions = ['csv', 'json', 'sql', 'txt'];
    const docsExtensions = ['doc', 'docx'];
    const xlsxExtensions = ['xls', 'xlsx'];
    const pptxExtensions = ['ppt', 'pptx'];
    const jpgExtensions = ['jpg', 'jpeg'];
    const pngExtensions = ['png'];
    const pdfExtensions = ['pdf'];

    if (imageExtensions.contains(extension)) {
      return Icon(Icons.image_rounded);
    } else if (pngExtensions.contains(extension)) {
      return BuildSvgIcon(
          assetName: "assets/svg/png.svg", index: 1, currentIndex: 1);
    } else if (jpgExtensions.contains(extension)) {
      return BuildSvgIcon(
          assetName: "assets/svg/jpg.svg", index: 1, currentIndex: 1);
    } else if (audioExtensions.contains(extension)) {
      return Icon(Icons.audio_file_outlined);
    } else if (videoExtensions.contains(extension)) {
      return Icon(Icons.video_file_sharp);
    } else if (dataExtensions.contains(extension)) {
      return Icon(Icons.dataset_rounded);
    } else if (xlsxExtensions.contains(extension)) {
      return BuildSvgIcon(
          assetName: "assets/svg/xlsx.svg", index: 1, currentIndex: 1);
    } else if (pptxExtensions.contains(extension)) {
      return BuildSvgIcon(
          assetName: "assets/svg/pptx.svg", index: 1, currentIndex: 1);
    } else if (docsExtensions.contains(extension)) {
      return BuildSvgIcon(
          assetName: "assets/svg/docx.svg", index: 1, currentIndex: 1);
    } else if (pdfExtensions.contains(extension)) {
      return BuildSvgIcon(
          assetName: "assets/svg/pdf.svg", index: 1, currentIndex: 1);
    } else {
      return Icon(Icons.insert_drive_file_outlined);
    }
  }

  bool _isImage(String? path) {
    if (path == null) return false;
    final extension = path.split('.').last.toLowerCase();
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension);
  }
}

// PDF Document	application/pdf
// ZIP Archive	application/zip
// GZIP Archive	application/gzip
// Excel (XLSX)	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
// Word Document	application/vnd.openxmlformats-officedocument.wordprocessingml.document
// PowerPoint	application/vnd.openxmlformats-officedocument.presentationml.presentation

// Executable	application/octet-stream

// MP4 Video	video/mp4
// WebM Video	video/webm
// Ogg Video	video/ogg
// AVI Video	video/x-msvideo
// MPEG Video	video/mpeg

// MP3 Audio	audio/mpeg
// AAC Audio	audio/aac
// Ogg Audio	audio/ogg
// WAV Audio	audio/wav
// WebM Audio	audio/webm

// JPEG Image	image/jpeg
// PNG Image	image/png
// GIF Image	image/gif
// BMP Image	image/bmp
// WebP Image	image/webp
// SVG (Vector)	image/svg+xml

// Plain Text	text/plain
// HTML	text/html
// CSS	text/css
// JavaScript	text/javascript
// JSON	application/json
// XML	application/xml

class CircularIconWithTitle extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color borderColor;
  final Color iconColor;
  final double borderWidth;
  final String title;
  final TextStyle titleStyle;
  final VoidCallback? onPressed;

  const CircularIconWithTitle(
      {super.key,
      required this.icon,
      this.iconSize = 40.0,
      this.borderColor = Colors.black12,
      this.borderWidth = 2.0,
      this.iconColor = Colors.black,
      required this.title,
      this.titleStyle = const TextStyle(fontSize: 14),
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(borderWidth), // Add padding for the border
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            onPressed: onPressed,
          ),
        ),
        SizedBox(height: 8.0), // Add spacing between the icon and the title
        Text(
          title,
          style: titleStyle,
        ),
      ],
    );
  }
}

class CircularImageWithTitle extends StatelessWidget {
  final double iconSize;
  final Color borderColor;
  final Color iconColor;
  final double borderWidth;
  final String title;
  final TextStyle titleStyle;
  final VoidCallback? onPressed;
  final String imagePath;

  const CircularImageWithTitle(
      {super.key,
      this.iconSize = 40.0,
      this.borderColor = Colors.black12,
      this.borderWidth = 2.0,
      this.iconColor = Colors.black,
      required this.title,
      this.titleStyle = const TextStyle(fontSize: 14),
      required this.onPressed,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(borderWidth), // Add padding for the border
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          constraints: BoxConstraints(
            maxWidth: 65.0,
            maxHeight: 65.0,
            minHeight: 65.0,
            minWidth: 65.0,

          ),
          child: GestureDetector(
            onTap: onPressed,
            child: Image(
              image: AssetImage(imagePath),
              // color: iconColor,
            ),
          ),
        ),

        SizedBox(height: 8.0), // Add spacing between the icon and the title
        Text(
          title,
          style: titleStyle,
        ),
      ],
    );
  }
}
