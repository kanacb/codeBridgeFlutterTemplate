import 'dart:convert';
import 'dart:io';

import 'package:aims/Utils/Services/IdName.dart';
import 'package:aims/Widgets/IrmsWarehouseParts/IrmsWarehouseParts.dart';
import 'package:aims/Widgets/IrmsWarehouseParts/IrmsWarehousePartsProvider.dart';
import 'package:flutter/material.dart';

import '../../Utils/Dialogs/ImageUploadField.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/SharedPreferences.dart';
import '../DocumentsStorage/UploaderService.dart';
import '../IrmsParts/IrmsParts.dart';
import '../IrmsParts/IrmsPartsProvider.dart';
import '../PartRequestDetails/PartRequestDetails.dart';
import '../PartRequestDetails/PartRequestDetailsProvider.dart';
import '../Users/User.dart';
import 'JobStationTicket.dart';
import 'JobStationTicketProvider.dart';

class JobStationTicketTechCloseDialog extends StatefulWidget {
  final JobStationTicket ticket;
  final dynamic machine;
  final VoidCallback onUpdated;
  final VoidCallback onHide;

  const JobStationTicketTechCloseDialog({
    super.key,
    required this.ticket,
    required this.machine,
    required this.onUpdated,
    required this.onHide,
  });

  @override
  State<JobStationTicketTechCloseDialog> createState() => _JobStationTicketTechCloseDialogState();
}

class _JobStationTicketTechCloseDialogState extends State<JobStationTicketTechCloseDialog> {
  late final User _user;
  Map<String, String> _errors = {};
  bool _submitting = false;
  bool _loading = false;
  List<String> _uploadOfPictureAfterRepairIds = [];
  List<PartRequestDetails> _approvedPartRequests = [];
  List<IrmsWarehouseParts> _irmsWarehouseParts = [];
  Map<String, bool> _partUsageStatus = {};
  Map<String, IrmsParts> _irmsPartsMap = {};
  List<File> _selectedImages = [];
  String _jobCarriedOut = '';
  String _comments = '';


  final UploaderService uploaderService = UploaderService();
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _jobCarriedOutController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _init();
    _resetForm();
  }

  Future<void> _init() async {
    await _loadPartRequestDetails();
    _user = User.fromJson(jsonDecode(await getPref("user") ?? ""));
  }

  @override
  void dispose() {
    _commentsController.dispose();
    _jobCarriedOutController.dispose();
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

  Future<void> _loadPartRequestDetails() async {
    setState(() {
      _loading = true;
    });

    List<PartRequestDetails> partRequestDetails = [];
    Response response = await PartRequestDetailsProvider().fetchByJobIdAndSave(widget.ticket.id!);
    if (response.error == null) {
      partRequestDetails = response.data;
    }

    _approvedPartRequests = partRequestDetails.where((request) => request.status == "Approved").toList();

    // Initialize usage status - default to true (used)
    for (var part in _approvedPartRequests) {
      _partUsageStatus[part.id!] = part.isUsed ?? true;
    }

    // Fetch IrmsParts for each part request
    for (var partRequest in _approvedPartRequests) {
      if (partRequest.partName != null && !_irmsPartsMap.containsKey(partRequest.partName)) {
        final irmsResponse = await IrmsPartsProvider().fetchOneAndSave(partRequest.partName!);
        if (irmsResponse.error == null) {
          _irmsPartsMap[partRequest.partName!] = irmsResponse.data;
        }
      }
    }

    await _loadIrmsWarehouseParts();

    setState(() {
      _loading = false;
    });
  }

  Future<void> _loadIrmsWarehouseParts() async {
    for (PartRequestDetails part in _approvedPartRequests) {
      Response response = await IrmsWarehousePartsProvider().fetchByPartIdAndSave(part.partName!);
      if (response.error == null) {
        _irmsWarehouseParts.addAll(response.data);
      }
    }
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _submitting = true;
    });

    Map<String, String> currentErrors = {};
    if (_selectedImages.isEmpty || _selectedImages.length > 3) {
      currentErrors['uploadOfPictureAfterRepair'] = "Please upload 1 to 3 images.";
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
      // make jobStationQueue update in backend first
      final updatedDataNoPic = {
        'endTime': DateTime.now().toUtc().toIso8601String(),
        'status': 'Closed',
        'jobCarriedOut': _jobCarriedOut,
        'comments': _comments,
      };
      final Response responseTicket = await JobStationTicketProvider().patchOneAndSave(widget.ticket.id!, updatedDataNoPic);
      if (responseTicket.error != null) {
        throw Exception(responseTicket.error);
      }

      // upload images
      Response responseUpload = await uploaderService.uploadFile(
        files: _selectedImages,
        id: widget.ticket.id!,
        serviceName: 'jobStationTickets',
      );
      if (responseUpload.error == null) {
        var data = jsonDecode(responseUpload.data);
        List<dynamic> results = data['results'];
        List<String> uploadedIds = results.map((item) => item['documentId'] as String).toList();
        _uploadOfPictureAfterRepairIds = uploadedIds;

        // patch it again with pic id
        final picData = {
          'uploadOfPictureAfterRepair': _uploadOfPictureAfterRepairIds,
        };

        final Response responsePicId = await JobStationTicketProvider().patchOneAndSave(widget.ticket.id!, picData);
        if(responsePicId.error != null) {
          throw Exception(responsePicId.error);
        }
      }
      else {
        print('Error closing ticket: ${responseUpload.error}');
        setState(() {
          _errors = {'form': responseUpload.error!};
        });
        return;
      }

      // update part request statuses and warehouse quantities
      for (var partRequest in _approvedPartRequests) {
        final isUsed = _partUsageStatus[partRequest.id] ?? true;

        // Update part request isUsed status
        final isUsedData = {
          'isUsed': isUsed,
        };

        final partUpdateResponse = await PartRequestDetailsProvider().patchOneAndSave(partRequest.id!, isUsedData);
        if(partUpdateResponse.error != null) {
          throw Exception(partUpdateResponse.error);
        }
        PartRequestDetails patchedPart = partUpdateResponse.data;
        print("part request updated ${patchedPart.id}");

        // If part is not used, add quantity back to warehouse
        if (!isUsed) {
          // Find the warehouse part
          final warehousePart = _irmsWarehouseParts.firstWhere((part) => part.part == partRequest.partName);

          // Add quantity back
          final newQuantity = (warehousePart.quantity ?? 0) + (partRequest.quantity ?? 0);

          final quantityData = {
            'quantity': newQuantity,
            'updatedBy': IdName(sId: _user.id, name: _user.name),
          };
          final warehousePartResponse = await IrmsWarehousePartsProvider().patchOneAndSave(warehousePart.id!, quantityData);
          if(warehousePartResponse.error != null) {
            throw Exception(warehousePartResponse.error);
          }
          IrmsWarehouseParts patchedWarehouse = warehousePartResponse.data;
          print("warehouse part updated ${patchedWarehouse.id}");
        }
      }

      if (context.mounted) {
        widget.onHide();
        widget.onUpdated();
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
                    'Ticket Closure (Level 1)',
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

                      // Job Carried Out Section
                      const Text(
                        'Job Carried Out:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _jobCarriedOutController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter comments...',
                          errorText: _errors['jobCarriedOut'],
                        ),
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            _jobCarriedOut = value;
                            _errors.remove('jobCarriedOut');
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Parts Request Section
                      _buildPartsChangedSection(),
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

                      // Comments/ Remarks Section
                      const Text(
                        'Comments/ Remarks:',
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
                            _comments = value;
                            _errors.remove('comments');
                          });
                        },
                      ),
                      const SizedBox(height: 16),

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
                    onPressed: _submitting || _loading ? null : _onSave,
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
      ),
    );
  }

  Widget _buildPartsChangedSection() {
    Widget content;

    if (_loading) {
      content = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_approvedPartRequests.isEmpty) {
      content = const Text("No approved parts requested for this job.");
    } else {
      content = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _approvedPartRequests.length,
        itemBuilder: (context, index) {
          final partRequest = _approvedPartRequests[index];
          final isUsed = _partUsageStatus[partRequest.id] ?? true;
          return _buildPartCard(partRequest, isUsed);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Parts Changed:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildPartCard(PartRequestDetails partRequest, bool isUsed) {
    final IrmsParts? irmsPart = _irmsPartsMap[partRequest.partName];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Part name
            Text(
              irmsPart?.description ?? 'Unknown Part',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            // Quantity
            Text('Qty: ${partRequest.quantity ?? 0}'),
            const SizedBox(height: 8),

            // Status tag
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isUsed ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isUsed ? 'Used' : 'Void',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Mark as label and radio buttons in a row
            Row(
              children: [
                const Text(
                  'Mark as:',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: RadioGroup<bool>(
                    groupValue: isUsed,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _partUsageStatus[partRequest.id!] = value;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Radio<bool>(value: true),
                            const Text('Used'),
                          ],
                        ),
                        const SizedBox(width: 8),

                        // Void radio button
                        Row(
                          children: [
                            Radio<bool>(value: false),
                            const Text('Void'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
