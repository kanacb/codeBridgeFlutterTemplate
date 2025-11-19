import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aims/Widgets/ExternalTickets/RaiseExternalTicketsProcess.dart';
import 'package:flutter/material.dart';

import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Dialogs/ImageUploadField.dart';
import '../../Utils/Services/IdName.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/SharedPreferences.dart';
import '../DocumentsStorage/UploaderService.dart';
import '../ExternalMachines/ExternalMachines.dart';
import '../ExternalMachines/ExternalMachinesProvider.dart';
import '../Users/User.dart';
import 'ExternalTickets.dart';
import 'ExternalTicketsPage.dart';
import 'ExternalTicketsProvider.dart';

class ReopenExternalTickets extends StatefulWidget {
  final ExternalTickets oldTicket;
  final Profile newVC;

  const ReopenExternalTickets({
    super.key,
    required this.oldTicket,
    required this.newVC,
  });

  @override
  State<ReopenExternalTickets> createState() => _ReopenExternalTicketsState();
}

class _ReopenExternalTicketsState extends State<ReopenExternalTickets> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final User _user;
  ExternalMachines? _machine;
  List<dynamic>? _checklists;
  List<dynamic>? _checks;
  bool _confirmationChecked = false;
  bool _isSubmitting = false;
  bool _isLoading = false;
  List<String> _selectedIssues = [];
  String? _additionalComments;
  List<String> _uploadOfMachineImagesIds = [];
  List<File> _selectedImages = [];
  Map<String, String> _errors = {};

  final UploaderService uploaderService = UploaderService();
  final RaiseExternalTicketsProcess _raiseExternalTicketsProcess = RaiseExternalTicketsProcess();


  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _isLoading = true;

    _user = User.fromJson(jsonDecode(await getPref("user") ?? ""));
    Response response = await ExternalMachinesProvider().fetchOneAndSave(widget.oldTicket.machineId!);
    if (response.error == null) _machine = response.data;
    await loadChecks(_machine!);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void submitTicket() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _errors.clear();
      });

      if (_selectedIssues.isEmpty) {
        _errors['issues'] = "Please select at least one issue.";
      }
      if (_selectedImages.isEmpty || _selectedImages.length > 3) {
        _errors['machineImages'] = "Please upload 1 to 3 images.";
      }
      if (_errors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errors.values.join("\n")),
          ),
        );
        return;
      }

      if (!_confirmationChecked) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please confirm the details.')));
        return;
      }

      setState(() {
        _isSubmitting = true;
      });
      // write the function to save the ticket.
      final ExternalTickets ticketData = ExternalTickets(
        machineId:widget.oldTicket.machineId,
        checklistResponse: _selectedIssues,
        assignedTechnician: null,
        status: "Open",
        startTime: DateTime.now().toUtc(),
        externalUser: IdName(sId: widget.newVC.id, name: widget.newVC.name),
        endTime: null,
        // comments: _additionalComments, // todo add this after webapp also added
        createdBy: IdName(sId: _user.id, name: _user.name),
        updatedBy: IdName(sId: _user.id, name: _user.name),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      try {
        // create new ticket without image
        Response newTicketResponse = await ExternalTicketsProvider().createOneAndSave(ticketData);
        if (newTicketResponse.error != null) {
          _showError(context, newTicketResponse.error!);
          return;
        }
        ExternalTickets newTicket = newTicketResponse.data;

        // upload image
        Response uploadResponse = await uploaderService.uploadFile(
          files: _selectedImages,
          id: newTicket.id!,
          serviceName: 'externalTickets',
        );
        if (uploadResponse.error != null) {
          await ExternalTicketsProvider().deleteOne(newTicket.id!);
          _showError(context, uploadResponse.error!);
          return;
        }

        // parse upload result
        final data = jsonDecode(uploadResponse.data);
        List<dynamic> results = data['results'];
        List<String> uploadedIds = results.map((item) => item['documentId'] as String).toList();
        _uploadOfMachineImagesIds = uploadedIds;

        //patch image id inside created ticket
        final newTicketImageUpdate = {
          'machineImage': _uploadOfMachineImagesIds,
        };
        final Response newTicketPatchedResponse = await ExternalTicketsProvider().patchOneAndSave(newTicket.id!, newTicketImageUpdate);
        if (newTicketPatchedResponse.error != null) {
          _showError(context, newTicketPatchedResponse.error!);
          return;
        }

        // patch old ticket
        final oldTicketReopenUpdate = {
          'status': 'Reopened',
          'updatedBy':  _user.id,
        };
        final Response oldTicketPatchedResponse = await ExternalTicketsProvider().patchOneAndSave(widget.oldTicket.id!, oldTicketReopenUpdate);
        if (oldTicketPatchedResponse.error != null) {
          _showError(context, oldTicketPatchedResponse.error!);
          return;
        }

        //success
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ExternalTicketsPage(
                successMessage:
                "Ticket reopened and new ticket submitted successfully!",
              ),
            ),
          );
        }
      } catch (e) {
        print("DEBUG RaiseTicket.dart $e");
        if (context.mounted) {
          _showError(context, e.toString());
        }
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
    else {
      print("state invalid");
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> loadChecks(ExternalMachines thisMachine) async {
    dynamic check = await _raiseExternalTicketsProcess.ChecklistsNChecks(context, thisMachine);
    _checks = check["checks"];
    _checklists = check["checklists"];
    log("checklists: ${check["checklists"].length}, checks: ${check["checks"].length}");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // if loading (submitting), prevent pop
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // some other navigator already popped it

        if (_isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please wait, submitting ticket..."),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        final shouldCancel = await showCancelConfirmationDialog(context);
        if (shouldCancel && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reopen Ticket'),
          backgroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          automaticallyImplyLeading: !_isSubmitting,
        ),
        body: _isLoading || _isSubmitting
            ? const Center(child: CircularProgressIndicator())
            : buildForm(context),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Machine info card
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    "Machine Serial",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  subtitle: Text(
                    "${_machine?.serialNumber ?? '-'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Checklist section
              Text(
                "Select Issues",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _checklists != null && _checklists!.isNotEmpty
                      ? checklistsChecksForm()
                      : const Text("No checklists available"),
                ),
              ),
              if (_errors['issues'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _errors['issues']!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),

              // Image upload
              Text(
                "Upload Pictures (1–3)",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ImageUploadField(
                    maxImages: 3,
                    initialImages: _selectedImages,
                    errorText: _errors['machineImages'],
                    onImagesChanged: (images) {
                      setState(() {
                        _selectedImages = images;
                        _errors.remove('machineImages');
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Comments
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Additional Comments',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                onSaved: (value) => _additionalComments = value,
              ),
              const SizedBox(height: 20),

              // Confirmation checkbox
              Row(
                children: [
                  Checkbox(
                    value: _confirmationChecked,
                    activeColor: Colors.red,
                    onChanged: (checked) {
                      setState(() => _confirmationChecked = checked ?? false);
                    },
                  ),
                  Expanded(
                    child: Text(
                      "I confirm the details are correct.",
                      style: TextStyle(color: Colors.grey[800], fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action buttons
              SafeArea(
                minimum: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        final shouldCancel =
                        await showCancelConfirmationDialog(context);
                        if (shouldCancel && mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: submitTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: const Text("Submit Ticket"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checklistsChecksForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      _checklists!.map((checklist) {
        final List checklistChecks = _checks!
            .where((check) => check.checkListId == checklist.id)
            .toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              checklist.name,
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...checklistChecks.map((check) {
              return CheckboxListTile(
                title: Text(check.name ?? ''),
                value: _selectedIssues.contains(check.name),
                onChanged: (checked) {
                  setState(() {
                    checked! ? _selectedIssues.add(check.name) : _selectedIssues.remove(check.name);
                    print(_selectedIssues);
                  });
                },
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }

  Future<bool> showCancelConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Cancel Ticket',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel? Unsaved changes will be lost.',
          style: TextStyle(fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false), // user chose No
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[400]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // user chose Yes
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    ) ?? false; // return false if dismissed
  }
}
