import 'dart:convert';
import 'dart:io';
import 'package:aims/Utils/Dialogs/ImageUploadField.dart';
import 'package:aims/Utils/Services/SharedPreferences.dart';
import 'package:aims/Widgets/AtlasTickets/AtlasTicketProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Services/IdName.dart';
import '../../Utils/Services/Response.dart';
import '../AtlasTickets/AtlasTicket.dart';
import '../AtlasTickets/AtlasTicketPage.dart';
import '../DocumentsStorage/UploaderService.dart';
import '../Users/User.dart';
import '/Utils/Globals.dart' as globals;
import '../../Widgets/AtlasMachines/AtlasMachines.dart';

class RaiseTicket extends StatefulWidget {
  final String qrCode;
  final Profile profile;
  final AtlasMachines machine;
  final List<dynamic> checklists;
  final List<dynamic> checks;
  const RaiseTicket({
    super.key,
    required this.qrCode,
    required this.profile,
    required this.machine,
    required this.checklists,
    required this.checks,
  });

  @override
  _RaiseTicketState createState() => _RaiseTicketState();
}

class _RaiseTicketState extends State<RaiseTicket> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final User user;
  String? selectedMachineId;
  List<String> selectedIssues = [];
  String? additionalComments;
  bool confirmationChecked = false;
  late List<AtlasMachines> machines = [];
  List<String> _uploadOfMachineImagesIds = [];
  List<File> _selectedImages = [];
  Map<String, String> _errors = {};

  final UploaderService uploaderService = UploaderService();


  bool isLoading = false;
  String status = "start";
  bool showKeyboard = true;
  Logger logger = globals.logger;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    user = User.fromJson(jsonDecode(await getPref("user") ?? ""));
  }

  void submitTicket() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _errors.clear();
      });

      if (selectedIssues.isEmpty) {
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

      if (!confirmationChecked) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please confirm the details.')));
        return;
      }

      setState(() {
        isLoading = true;
      });
      // write the function to save the ticket.
      final AtlasTicket ticketData = AtlasTicket(
        machineId:widget.machine.id!,
        checklistResponse: selectedIssues,
        assignedTechnician: null,
        status: "Open",
        startTime: DateTime.now().toUtc(),
        vendingController: IdName(sId: widget.profile.id, name: widget.profile.name),
        endTime: null,
        comments: additionalComments,
        createdBy: IdName(sId: user.id, name: user.name),
        updatedBy: IdName(sId: user.id, name: user.name),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      print("Datetime ${DateTime.now().toUtc()}");
      print("Datetime toString ${DateTime.now().toUtc().toIso8601String()}");

      try {
        // create ticket without image
        Response responseTicket = await AtlasTicketProvider().createOneAndSave(ticketData);
        if (responseTicket.error == null) {
          AtlasTicket ticket = responseTicket.data;

          // upload image
          Response responseUpload = await uploaderService.uploadFile(
            files: _selectedImages,
            id: ticket.id!,
            serviceName: 'atlasTickets',
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

            final Response patchedTicket = await AtlasTicketProvider().patchOneAndSave(ticket.id!, updatedData);
            if (patchedTicket.error == null) {
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AtlasTicketPage(
                      successMessage: "Ticket submitted successfully!",
                    ),
                  ),
                );
              }
            }
          }
          // picture upload error
          else {
            await AtlasTicketProvider().deleteOne(ticket.id!);
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
        if (kDebugMode) print("DEBUG RaiseTicket.dart $e");
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red,),
        );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
    else {
      print("state invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading, // if loading, prevent pop
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && isLoading) {
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
          title: const Text('Raise Ticket'),
          backgroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Stack(
          children: [
            buildForm(context),

            if (isLoading)
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
                    "${widget.machine.serialNumber}",
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
                onSaved: (value) => additionalComments = value,
              ),
              const SizedBox(height: 20),
        
              // Confirmation checkbox
              Row(
                children: [
                  Checkbox(
                    value: confirmationChecked,
                    activeColor: Colors.red,
                    onChanged: (checked) {
                      setState(() => confirmationChecked = checked ?? false);
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
          widget.checklists.map((checklist) {
            final List checklistChecks = widget.checks
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
                    value: selectedIssues.contains(check.name),
                    onChanged: (checked) {
                      setState(() {
                        checked! ? selectedIssues.add(check.name) : selectedIssues.remove(check.name);
                        print(selectedIssues);
                      });
                    },
                  );
                }).toList(),
              ],
            );
          }).toList(),
    );
  }
}
