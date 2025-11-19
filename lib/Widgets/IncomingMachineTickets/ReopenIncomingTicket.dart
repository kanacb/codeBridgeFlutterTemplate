import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:aims/Utils/Dialogs/ImageUploadField.dart';
import 'package:aims/Utils/Services/SharedPreferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Services/IdName.dart';
import '../../Utils/Services/Response.dart';
import '../AtlasMachines/AtlasMachinesProvider.dart';
import '../DocumentsStorage/UploaderService.dart';
import '../ExternalMachines/ExternalMachinesProvider.dart';
import '../IrmsMachines/IrmsMachinesProvider.dart';
import '../MemMachines/MemMachinesProvider.dart';
import '../Users/User.dart';
import '/Utils/Globals.dart' as globals;
import 'ChecklistResponse.dart';
import 'IncomingMachineTicket.dart';
import 'IncomingMachineTicketPage.dart';
import 'IncomingMachineTicketProvider.dart';
import 'RaiseIncomingTicketProcess.dart';

class ReopenIncomingTicket extends StatefulWidget {
  final IncomingMachineTicket oldTicket;
  final Profile newIMC;

  const ReopenIncomingTicket({
    super.key,
    required this.oldTicket,
    required this.newIMC,
  });

  @override
  _ReopenIncomingTicketState createState() => _ReopenIncomingTicketState();
}

class _ReopenIncomingTicketState extends State<ReopenIncomingTicket> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final User _user;
  List<ChecklistResponse> _checklistResponse = [];
  Map<String, String> _selectedResponses = {};
  String? _additionalComments;
  bool _confirmationChecked = false;
  dynamic _machine;
  List<dynamic>? _checklists;
  List<dynamic>? _checks;
  List<String> _uploadOfMachineImagesIds = [];
  List<File> _selectedImages = [];
  Map<String, String> _errors = {};

  final UploaderService _uploaderService = UploaderService();
  final _raiseIncomingTicketProcess = RaiseIncomingTicketProcess();


  bool _isLoading = false;
  bool _isSubmitting = false;

  bool showKeyboard = true;
  Logger logger = globals.logger;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });

    _user = User.fromJson(jsonDecode(await getPref("user") ?? ""));

    Response response = await IrmsMachinesProvider().fetchOneAndSave(widget.oldTicket.machineId!);
    if (response.data == null) {
      response = await AtlasMachinesProvider().fetchOneAndSave(widget.oldTicket.machineId!);
    }
    if (response.data == null) {
      response = await MemMachinesProvider().fetchOneAndSave(widget.oldTicket.machineId!);
    }
    if (response.data  == null) {
      response = await ExternalMachinesProvider().fetchOneAndSave(widget.oldTicket.machineId!);
    }
    if (response.error == null) _machine = response.data;
    await _loadChecks();

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

      if (_checklistResponse.isEmpty) {
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
      final IncomingMachineTicket ticketData = IncomingMachineTicket(
        machineId: widget.oldTicket.machineId,
        machineService: widget.oldTicket.machineService,
        vendingControllerChecklistResponse: _checklistResponse,
        selectedJobStations: [],
        status: "Open",
        startTime: DateTime.now().toUtc(),
        incomingMachineChecker: IdName(sId: widget.newIMC.id, name: widget.newIMC.name),
        endTime: null,
        comments: _additionalComments,
        createdBy: IdName(sId: _user.id, name: _user.name),
        updatedBy: IdName(sId: _user.id, name: _user.name),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      print("Datetime ${DateTime.now().toUtc()}");
      print("Datetime toString ${DateTime.now().toUtc().toIso8601String()}");

      try {
        // create ticket without image
        Response responseTicket = await IncomingMachineTicketProvider().createOneAndSave(ticketData);
        if (responseTicket.error == null) {
          IncomingMachineTicket ticket = responseTicket.data;

          // upload image
          Response responseUpload = await _uploaderService.uploadFile(
            files: _selectedImages,
            id: ticket.id!,
            serviceName: 'incomingMachineTickets',
          );

          if (responseUpload.error == null) {
            //take uploaded image id
            var data = jsonDecode(responseUpload.data);
            List<dynamic> results = data['results'];
            List<String> uploadedIds = results.map((item) => item['documentId'] as String).toList();
            _uploadOfMachineImagesIds = uploadedIds;

            // patch image id inside created ticket
            final updatedData = {
              'machineImage': _uploadOfMachineImagesIds,
            };

            final Response patchedTicket = await IncomingMachineTicketProvider().patchOneAndSave(ticket.id!, updatedData);
            if (patchedTicket.error == null) {

              // patch old ticket
              final oldTicketReopenUpdate = {
                'status': 'Reopened',
                'updatedBy':  _user.id,
              };
              final Response oldTicketPatchedResponse = await IncomingMachineTicketProvider().patchOneAndSave(widget.oldTicket.id!, oldTicketReopenUpdate);
              if (oldTicketPatchedResponse.error == null) {
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => IncomingMachineTicketPage(
                        successMessage: "Ticket reopened and new ticket submitted successfully!",
                      ),
                    ),
                  );
                }
              }
            }
          }
          // picture upload error
          else {
            await IncomingMachineTicketProvider().deleteOne(ticket.id!);
            if (kDebugMode) print(responseUpload.error);
            if(context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('There was an error when uploading image: ${responseUpload.error}'), backgroundColor: Colors.red,),
              );
            }
          }
        }
        else {
          if (kDebugMode) print(responseTicket.error);
          if(context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseTicket.error}'), backgroundColor: Colors.red,),
            );
          }
        }
      } catch (e) {
        if (kDebugMode) print("DEBUG RaiseIncomingTicket.dart $e");
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red,),
          );
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

  Future<void> _loadChecks() async {
    dynamic check = await _raiseIncomingTicketProcess.ChecklistsNChecks(context);
    _checks = check["checks"];
    _checklists = check["checklists"];
    log("checklists: ${check["checklists"].length}, checks: ${check["checks"].length}");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitting, // if loading, prevent pop
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please wait, submitting ticket..."),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reopen Incoming Machine Ticket'),
          backgroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            buildForm(context),

            if (_isSubmitting)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
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
                    "${_machine.serialNumber}",
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
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: checklistsChecksForm(),
                ),
              ),
              if (_errors['issues'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_errors['issues']!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 20),

              // Image upload
              Text(
                "Upload Pictures (1–3)",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  labelText: "Additional Comments",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                minimum: const EdgeInsets.only(bottom: 16), // extra padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: submitTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            RadioGroup<String>(
              groupValue: _selectedResponses[checklist.id],
              onChanged: (String? value) {
                setState(() {
                  _selectedResponses[checklist.id] = value!;

                  // Remove existing response for this checklist
                  _checklistResponse.removeWhere((item) => item.checkListId?.sId == checklist.id);

                  // Find the selected check to get its ID
                  final selectedCheck = checklistChecks.firstWhere((check) => check.name == value);

                  _checklistResponse.add(
                    ChecklistResponse(
                      checkListId: IdName(sId: checklist.id, name: checklist.name),
                      checkId: selectedCheck.id,
                      responseValue: value,
                    ),
                  );
                });
                print(_checklistResponse.map((item) => item.responseValue).toList());
              },
              child: Column(
                children: checklistChecks.map((check) =>
                    RadioListTile<String>(
                      title: Text(check.name),
                      value: check.name,
                    ),
                ).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
