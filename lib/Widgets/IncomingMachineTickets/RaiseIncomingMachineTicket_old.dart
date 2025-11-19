import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../IncomingMachineChecklists/IncomingMachineChecklists.dart';
import '../IncomingMachineChecklists/IncomingMachineChecklistsProvider.dart';
import '../IncomingMachineChecks/IncomingMachineChecks.dart';
import '../IncomingMachineChecks/IncomingMachineChecksProvider.dart';
import '../MachineMaster/MachineMaster.dart';
import '../MachineMaster/MachineMasterProvider.dart';

class IncomingChecksForm extends StatefulWidget {
  @override
  _IncomingChecksFormState createState() => _IncomingChecksFormState();
}

class _IncomingChecksFormState extends State<IncomingChecksForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedMachineId;
  List<String> selectedIssues = [];
  String? additionalComments;
  bool confirmationChecked = false;

  late List<MachineMaster> machines;
  late List<IncomingMachineChecklists> checklists;
  late List<IncomingMachineChecks> checks;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Fetch necessary data
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await MachineMasterProvider().fetchAllAndSave();
      await IncomingMachineChecklistsProvider().fetchAllAndSave();
      await IncomingMachineChecksProvider().fetchAllAndSave();

      machines = await Provider.of<MachineMasterProvider>(context, listen: false).data.toList();
      checklists = await Provider.of<IncomingMachineChecklistsProvider>(context, listen: false).data.toList();
      checks = await Provider.of<IncomingMachineChecksProvider>(context, listen: false).data.toList();
      machines.sort((a, b) => int.parse(b.serialNumber ?? "0").compareTo(int.parse(a.serialNumber ?? "0")));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: $error')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle ticket submission
  void submitTicket() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (selectedIssues.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select at least one issue.')));
        return;
      }

      if (!confirmationChecked) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please confirm the details.')));
        return;
      }

      // Logic for ticket submission (e.g., API call)
      print('Machine ID: $selectedMachineId');
      print('Selected Issues: $selectedIssues');
      print('Additional Comments: $additionalComments');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket submitted successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('Raise Incoming Machine Ticket')),
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
                // Machine Selection Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Machine Serial No'),
                  items: machines.map((machine) {
                    return DropdownMenuItem<String>(
                      value: machine.serialNumber,
                      child: Text("${machine.serialNumber} - ${machine.vendingMachineType}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMachineId = value;
                    });
                    // getChecksNChecklists(value);
                  },
                  validator: (value) => value == null ? 'Please select a machine.' : null,
                ),
                SizedBox(height: 16.0),

                // Checklist Section
                Text('Checklist - Select Issues:', style: TextStyle(fontWeight: FontWeight.bold)),
                checklists.isNotEmpty ? checklistsChecksForm() : SizedBox.shrink(),
                SizedBox(height: 16.0),

                // Additional Comments Field
                TextFormField(
                  decoration: InputDecoration(labelText: 'Additional Comments'),
                  maxLines: 3,
                  onSaved: (value) => additionalComments = value,
                ),
                SizedBox(height: 16.0),

                // Confirmation Checkbox
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
                      child: Text('I confirm that all details provided are correct.'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                // Submit & Close Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: submitTicket, child: Text('Submit Ticket')),
                    OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dynamically generate checklist options based on selected machine
  Widget checklistsChecksForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: checklists.map((checklist) {
        return Column(
          children: [
            SizedBox(height: 8.0),
            Text(checklist.name, style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: checks.where((check) {
                return check.checkListId == checklist.id; // Filter checks based on checklist
              }).map((check) {
                return CheckboxListTile(
                  title: Text(check.name),
                  value: selectedIssues.contains(check.name),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedIssues.add(check.name);
                      } else {
                        selectedIssues.remove(check.name);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Fetch and filter checklists based on selected machine type
  void getChecksNChecklists(String? machineId) {
    setState(() {
      checklists = checklists.where((checklist) {
        // Filtering logic based on machine type
        return checklist.name == machines.firstWhere((machine) => machine.serialNumber == machineId).vendingMachineType?.name ;
      }).toList();
    });
  }
}
