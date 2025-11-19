import 'dart:convert';

import '../../Widgets/ExternalChecklists/ExternalChecklists.dart';
import '../../Widgets/ExternalChecks/ExternalChecks.dart';
import '../../Widgets/MachineMaster/MachineMaster.dart';
import '../../Widgets/MachineMaster/MachineMasterProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ExternalChecklists/ExternalChecklistsProvider.dart';
import '../ExternalChecks/ExternalChecksProvider.dart';

class RaiseExternalTicketPage extends StatefulWidget {
  @override
  _RaiseTicketPageState createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends State<RaiseExternalTicketPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedMachineId;
  List<String> selectedIssues = [];
  String? additionalComments;
  bool confirmationChecked = false;
  late List<MachineMaster> machines = [];
  List<ExternalChecklists> checklists = [];
  List<ExternalChecks> checks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool checklistsForVendingTypeId({
    required ExternalChecklists externalChecklists,
    required String value,
  }) {
    final MachineMaster selectedMachine =
        machines.firstWhere((v) => v.serialNumber == value);
    return externalChecklists.vendingMachineId?.name ==
        selectedMachine.vendingMachineType;
  }

  bool checksForCheckListsVendingTypeId(ExternalChecks externalChecks) {
    final List<ExternalChecklists> matchingChecklists =
        checklists.where((v) => v.id == externalChecks.checkListId).toList();
    return matchingChecklists.isNotEmpty;
  }



  Future<void> loadData() async {
    try {
      await MachineMasterProvider().fetchAllAndSave();
      await ExternalChecklistsProvider().fetchAllAndSave();
      await ExternalChecksProvider().fetchAllAndSave();

      List<MachineMaster> allMachines =
          Provider.of<MachineMasterProvider>(context, listen: false).data;

      // Filtering out internal machines
      machines = allMachines.where((machine) {
        final String? companyId = machine.ownership.companyId.name; // Now treating companyId as a string
        return companyId != "Atlas Vending(M) Sdn Bhd" &&
            companyId != "Atlas" &&
            companyId != "IRMS" &&
            companyId != "IRMS Sdn Bhd";
      }).toList();

      // Sorting safely
      machines.sort((a, b) => (a.serialNumber ?? '').compareTo(b.serialNumber ?? ''));

      checklists = Provider.of<ExternalChecklistsProvider>(context, listen: false).data.cast<ExternalChecklists>();
      checks = Provider.of<ExternalChecksProvider>(context, listen: false).data.cast<ExternalChecks>();

      setState(() {
        isLoading = false;
      });

      print('Filtered Machines Count: ${machines.length}');
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $error')),
      );
    }
  }


  Future<void> getChecksNChecklists(String value) async {
    checklists =
        await Provider.of<ExternalChecklistsProvider>(context, listen: false)
            .data
            .where((v) =>
                checklistsForVendingTypeId(externalChecklists: v, value: value))
            .toList();

    checks = await Provider.of<ExternalChecksProvider>(context, listen: false)
        .data
        .where((check) => checksForCheckListsVendingTypeId(check))
        .toList();

    setState(() {});
  }

  void submitTicket() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (selectedIssues.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one issue.')),
        );
        return;
      }

      if (!confirmationChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please confirm the details.')),
        );
        return;
      }

      print('Machine ID: $selectedMachineId');
      print('Selected Issues: $selectedIssues');
      print('Additional Comments: $additionalComments');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Raise Ticket Checklist')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration:
                            InputDecoration(labelText: 'Machine Serial No'),
                        items: machines
                            .map(
                              (machine) => DropdownMenuItem<String>(
                                value: machine.id,
                                child: Text(
                                    "${machine.serialNumber} - ${machine.vendingMachineType?.name} - ${machine.vendingMachineCode}"),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMachineId = value;
                            if (value != null) {
                              print(value);
                              final List<MachineMaster> selectedMachineObj = machines.where((m) => m.id == value).toList();
                              getChecksNChecklists(selectedMachineObj[0].vendingMachineType!.sId!);
                            }
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a machine.' : null,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Checklist - Please Select Issues with the Machine:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      checklists.isNotEmpty
                          ? checklistsChecksForm()
                          : SizedBox.shrink(),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Additional Comments'),
                        maxLines: 3,
                        onSaved: (value) => additionalComments = value,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Checkbox(
                            value: confirmationChecked,
                            onChanged: (checked) {
                              setState(() {
                                confirmationChecked = checked ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                                'I confirm that all the details provided are true and correct.'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: submitTicket,
                            child: Text('Submit Ticket'),
                          ),
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget checklistsChecksForm() {
    selectedIssues = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: checklists.map((checklist) {
        final List<ExternalChecks> checklistChecks =
            checks.where((check) => check.checkListId == checklist.id).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              checklist.name ?? "N/A",
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...checklistChecks.map((check) {
              return CheckboxListTile(
                title: Text(check.name ?? ''),
                value: selectedIssues.contains(check.name),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      selectedIssues.add(check.name!);
                    } else {
                      selectedIssues.remove(check.name);
                    }
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
