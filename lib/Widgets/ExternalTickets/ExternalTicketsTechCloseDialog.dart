import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../Utils/Dialogs/ImageUploadField.dart';
import '../../Utils/Services/Response.dart';
import '../DocumentsStorage/UploaderService.dart';
import 'ExternalTickets.dart';
import 'ExternalTicketsProvider.dart';

class ExternalTicketsTechCloseDialog extends StatefulWidget {
  final ExternalTickets ticket;
  final VoidCallback onUpdated;
  final VoidCallback onHide;

  const ExternalTicketsTechCloseDialog({
    super.key,
    required this.ticket,
    required this.onUpdated,
    required this.onHide,
  });

  @override
  State<ExternalTicketsTechCloseDialog> createState() => _ExternalTicketsTechCloseDialogState();
}

class _ExternalTicketsTechCloseDialogState extends State<ExternalTicketsTechCloseDialog> {
  Map<String, String> _errors = {};
  bool _loading = false;
  List<String> _uploadOfPictureAfterRepairIds = [];
  List<File> _selectedImages = [];
  String? _selectedStatus;
  String _closingRemarks = '';

  final UploaderService uploaderService = UploaderService();
  final TextEditingController _commentsController = TextEditingController();

  final List<Map<String, String>> statusOptions = [
    {'label': 'Repaired', 'value': 'Repaired'},
    {'label': 'Incomplete', 'value': 'Incomplete'},
  ];

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  void _clearAllMessages() {
    setState(() {
      _errors.clear();
    });
  }

  Future<void> _onSave() async {
    setState(() {
      _loading = true;
    });

    Map<String, String> currentErrors = {};
    if (_selectedImages.isEmpty || _selectedImages.length > 3) {
      currentErrors['uploadOfPictureAfterRepair'] = "Please upload 1 to 3 images.";
    }
    if (_selectedStatus == null || _selectedStatus!.isEmpty) {
      currentErrors['status'] = "Please select a status.";
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
        serviceName: 'externalTickets',
      );
      if (responseUpload.error == null) {
        var data = jsonDecode(responseUpload.data);
        List<dynamic> results = data['results'];
        List<String> uploadedIds = results.map((item) => item['documentId'] as String).toList();
        _uploadOfPictureAfterRepairIds = uploadedIds;

        final updatedData = {
          'status': _selectedStatus,
          'endTime': DateTime.now().toUtc().toIso8601String(),
          'technicianEndTime': DateTime.now().toUtc().toIso8601String(),
          'closingRemarks': _closingRemarks,
          'uploadOfPictureAfterRepair': _uploadOfPictureAfterRepairIds,
        };

        final Response responseTicket = await ExternalTicketsProvider().patchOneAndSave(widget.ticket.id!, updatedData);
        if(responseTicket.error == null) {
          if (context.mounted) {
            widget.onHide();
            widget.onUpdated();
          }
        }
      }
      else {
        print('Error closing ticket: ${responseUpload.error}');
        setState(() {
          _errors = {'form': responseUpload.error!};
        });
      }
    } catch (err) {
      print('Error closing ticket: $err');
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
                  'Close Ticket',
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
                    // Status Dropdown Section
                    const Text(
                      'Status:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        errorText: _errors['status'],
                        hintText: 'Select status',
                      ),
                      items: statusOptions.map((status) {
                        return DropdownMenuItem<String>(
                          value: status['value'],
                          child: Text(status['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                          _errors.remove('status');
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Image Upload Section
                    const Text(
                      'Upload Picture After Repair (1 to 3):',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),

                    ImageUploadField(
                      maxImages: 3,
                      initialImages: _selectedImages,
                      errorText: _errors['uploadOfPictureAfterRepair'],
                      onImagesChanged: (images) {
                        setState(() {
                          _selectedImages = images;
                          _errors.remove('uploadOfPictureAfterRepair');
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Comments Section
                    const Text(
                      'Comments:',
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
                      onChanged: (value) {
                        setState(() {
                          _closingRemarks = value;
                          _errors.remove('comments');
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
    );
  }
}
