import 'dart:convert';
import 'dart:io';

import 'package:aims/Widgets/MemMachines/MemMachines.dart';
import 'package:aims/Widgets/MemParts/MemParts.dart';
import 'package:aims/Widgets/MemParts/MemPartsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/Dialogs/ImageUploadField.dart';
import '../../Utils/Services/Response.dart';
import '../DocumentsStorage/UploaderService.dart';
import 'MemTicket.dart';
import 'MemTicketProvider.dart';

class MemTicketTechCloseDialog extends StatefulWidget {
  final MemTicket ticket;
  final MemMachines machine;
  final VoidCallback onUpdated;
  final VoidCallback onHide;

  const MemTicketTechCloseDialog({
    super.key,
    required this.ticket,
    required this.machine,
    required this.onUpdated,
    required this.onHide,
  });

  @override
  State<MemTicketTechCloseDialog> createState() => _MemTicketTechCloseDialogState();
}

class _MemTicketTechCloseDialogState extends State<MemTicketTechCloseDialog> {
  Map<String, String> _errors = {};
  bool _submitting = false;
  bool _loading = false;
  List<String> _uploadOfPictureAfterRepairIds = [];
  List<File> _selectedImages = [];
  List<MemParts> _compatibleMemParts = [];
  String? _selectedStatus;
  String _closingRemarks = '';

  // Parts related
  String? _selectedPartId;
  int _partQuantity = 1;
  List<Map<String, dynamic>> _usedParts = []; // have partId, partName, quantity

  final UploaderService uploaderService = UploaderService();
  final TextEditingController _commentsController = TextEditingController();

  final List<Map<String, String>> statusOptions = [
    {'label': 'Repaired', 'value': 'Repaired'},
    {'label': 'Incomplete', 'value': 'Incomplete'},
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadMemParts();
  }

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

  Future<void> _loadMemParts() async {
    setState(() {
      _loading = true;
    });

    final partProvider = Provider.of<MemPartsProvider>(context, listen: false);
    await partProvider.fetchAllAndSave();

    List<MemParts> memParts = partProvider.data;
    _compatibleMemParts = memParts
        .where((part) => (part.machineType ?? [])
        .contains(widget.machine.vendingMachineType?.sId))
        .toList();

    setState(() {
      _loading = false;
    });
  }

  void _addPart() {
    Map<String, String> errors = {};

    if (_selectedPartId == null) {
      errors['part'] = 'Please select a part';
    }
    if (_partQuantity < 1) {
      errors['quantity'] = 'Quantity must be at least 1';
    }

    if (errors.isNotEmpty) {
      setState(() {
        _errors.addAll(errors);
      });
      return;
    }

    final part = _compatibleMemParts.firstWhere((p) => p.id == _selectedPartId);
    setState(() {
      _usedParts.add({
        'partId': _selectedPartId,
        'partName': part.item ?? 'Unknown Part',
        'quantity': _partQuantity,
      });
      _selectedPartId = null;
      _partQuantity = 1;
      _errors.remove('part');
      _errors.remove('quantity');
    });
  }

  void _removePart(int index) {
    setState(() {
      _usedParts.removeAt(index);
    });
  }

  Future<void> _onSave() async {
    setState(() {
      _submitting = true;
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
        _submitting = false;
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
        serviceName: 'memTickets',
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
          'usedParts': _usedParts.map((part) => {
            'partId': part['partId'],
            'quantity': part['quantity'],
          }).toList(),
        };

        final Response responseTicket = await MemTicketProvider().patchOneAndSave(widget.ticket.id!, updatedData);
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
        _submitting = false;
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

                    // Add Used Parts Section
                    _buildPartsSection(),

                    // Used Parts List
                    _buildUsedPartsSection(),
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

                    // Closing Remarks Section
                    const Text(
                      'Closing Remarks:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _commentsController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Please state if used salvaged spare parts.',
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
                  onPressed: _submitting ? null : () {widget.onHide();},
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submitting ? null : _onSave,
                  child: _submitting
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

  Widget _buildPartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Used Parts:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),

        // Loading state
        if (_loading)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 2),
                SizedBox(width: 12),
                Text("Loading available parts..."),
              ],
            ),
          )

        // Empty state
        else if (_compatibleMemParts.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "No compatible parts found for this machine.",
              style: TextStyle(color: Colors.grey),
            ),
          )

        // Normal UI
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _selectedPartId,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Select a part',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    errorText: _errors['part'],
                  ),
                  items: _compatibleMemParts.map((part) {
                    return DropdownMenuItem<String>(
                      value: part.id,
                      child: Text(
                        part.item ?? 'Unknown Part',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPartId = value;
                      _errors.remove('part');
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_partQuantity > 1) _partQuantity--;
                                  _errors.remove('quantity');
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                _partQuantity.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (_partQuantity < 100) _partQuantity++;
                                  _errors.remove('quantity');
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _addPart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add Part',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                if (_errors['quantity'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _errors['quantity']!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildUsedPartsSection() {
    if (_usedParts.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Used Parts List',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ..._usedParts.asMap().entries.map((entry) {
                final index = entry.key;
                final part = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part['partName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Quantity: ${part['quantity']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => _removePart(index),
                        tooltip: 'Remove Part',
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}