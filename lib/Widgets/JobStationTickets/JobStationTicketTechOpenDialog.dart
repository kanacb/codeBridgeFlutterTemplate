import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../Utils/Dialogs/ImageUploadField.dart';
import '../../Utils/Services/Response.dart';
import '../DocumentsStorage/UploaderService.dart';
import 'JobStationTicket.dart';
import 'JobStationTicketProvider.dart';

class JobStationTicketTechOpenDialog extends StatefulWidget {
  final JobStationTicket ticket;
  final dynamic machine;
  final VoidCallback onUpdated;
  final VoidCallback onHide;

  const JobStationTicketTechOpenDialog({
    super.key,
    required this.ticket,
    required this.machine,
    required this.onUpdated,
    required this.onHide,
  });

  @override
  State<JobStationTicketTechOpenDialog> createState() => _JobStationTicketTechOpenDialogState();
}

class _JobStationTicketTechOpenDialogState extends State<JobStationTicketTechOpenDialog> {
  Map<String, String> _errors = {};
  bool _loading = false;
  List<String> _uploadOfPictureBeforeRepairIds = [];
  List<File> _selectedImages = [];
  String _incomingRemarks = '';

  final UploaderService uploaderService = UploaderService();
  final TextEditingController _commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetForm();
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _selectedImages.clear();
    _errors.clear();
  }

  void _clearAllMessages() {
    setState(() {
      _errors.clear();
    });
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
    });

    Map<String, String> currentErrors = {};
    if (_selectedImages.isEmpty || _selectedImages.length > 3) {
      currentErrors['uploadOfPictureBeforeRepair'] = "Please upload 1 to 3 images.";
    }
    if (currentErrors.isNotEmpty) {
      setState(() {
        _errors = currentErrors;
        _loading = false;
      });
      return;
    }
    setState(() {
      _clearAllMessages();
    });

    try {
      Response responseUpload = await uploaderService.uploadFile(
        files: _selectedImages,
        id: widget.ticket.id!,
        serviceName: 'jobStationTickets',
      );
      if (responseUpload.error == null) {
        var data = jsonDecode(responseUpload.data);
        List<dynamic> results = data['results'];
        List<String> uploadedIds = results.map((item) => item['documentId'] as String).toList();
        _uploadOfPictureBeforeRepairIds = uploadedIds;

        final updatedData = {
          'startTime': DateTime.now().toUtc().toIso8601String(),
          'status': 'In Progress',
          'uploadOfPictureBeforeRepair': _uploadOfPictureBeforeRepairIds,
          'incomingRemarks': _incomingRemarks,
        };

        final Response responseTicket = await JobStationTicketProvider().patchOneAndSave(widget.ticket.id!, updatedData);
        if(responseTicket.error == null) {
          if (context.mounted) {
            widget.onHide();
            widget.onUpdated();
          }
        }
      }
      else {
        print('Error opening ticket: ${responseUpload.error}');
        setState(() {
          _errors = {'form': responseUpload.error!};
        });
      }
    } catch (err) {
      print('Error opening ticket: $err');
      setState(() {
        _errors = {'form': err.toString().isNotEmpty ? err.toString() : 'An unexpected error occurred.'};
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          constraints: const BoxConstraints(minWidth: 450),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Ticket (Level 1)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onHide();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Machine ID (Serial No) Section
                      const Text(
                        'Machine ID:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.machine.serialNumber ?? "-"),
                      const SizedBox(height: 16),

                      //Incoming Remarks Section
                      const Text(
                        'Incoming Remarks:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _commentsController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter comments...',
                          errorText: _errors['comments'],
                        ),
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            _incomingRemarks = value;
                            _errors.remove('comments');
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Image Upload Section
                      const Text(
                        'Upload Picture Before Repair (1 to 3):',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),

                      ImageUploadField(
                        maxImages: 3,
                        initialImages: _selectedImages,
                        errorText: _errors['uploadOfPictureBeforeRepair'],
                        onImagesChanged: (images) {
                          setState(() {
                            _selectedImages = images;
                            _errors.remove('uploadOfPictureBeforeRepair');
                          });
                        },
                      ),

                      // Form error message
                      if (_errors.containsKey('form'))
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _errors['form']!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Footer buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _loading ? null : () {widget.onHide();},
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _onSave,
                    child: _loading
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Confirm'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
