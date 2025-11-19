import 'dart:developer';

import 'package:aims/App/MenuBottomBar/Profile/Profile.dart';
import 'package:aims/App/MenuBottomBar/Profile/ProfileProvider.dart';
import 'package:flutter/material.dart';

import '../../Utils/Methods.dart';
import '../../Utils/Services/Response.dart';
import '../Positions/Positions.dart';
import '../Positions/PositionsProvider.dart';
import 'MemTicket.dart';
import 'MemTicketProvider.dart';

class MemTicketAssignTechDialog extends StatefulWidget {
  final MemTicket ticket;
  final Profile selectedProfile;
  final VoidCallback onUpdated;
  final VoidCallback? onCancel;

  const MemTicketAssignTechDialog({
    super.key,
    required this.ticket,
    required this.selectedProfile,
    required this.onUpdated,
    this.onCancel,
  });

  @override
  State<MemTicketAssignTechDialog> createState() => _MemTicketAssignTechDialogState();
}

class _MemTicketAssignTechDialogState extends State<MemTicketAssignTechDialog> {
  List<Profile> memTechnicians = [];
  Profile? selectedTechnician;
  bool loading = false;
  String? error;

  late DateTime supervisorStartTime;

  @override
  void initState() {
    super.initState();
    supervisorStartTime = DateTime.now().toUtc();
    fetchTechnicians();
  }

  Future<void> fetchTechnicians() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      // Fetch all technician profiles by position ID
      final Response responsePosition = await PositionsProvider().fetchByNameAndSave("Technician");
      List<Positions> positions = responsePosition.data;

      final Response responseProfile = await ProfileProvider().find("position", positions[0].id!);
      if (responseProfile.error != null) {
        setState(() {
          error = "Error fetching technician profiles: ${responseProfile.error}";
          memTechnicians = [];
        });
        return;
      }

      final List<Profile>? unfilteredTechnicians = responseProfile.data;
      if (unfilteredTechnicians == null || unfilteredTechnicians.isEmpty) {
        setState(() {
          error = "No technicians found from an 'mem' company.";
          memTechnicians = [];
        });
        return;
      }

      // Filter technicians by companyType == 'etika' and by Supervisor's branch
      final List<Profile> filtered = unfilteredTechnicians
          .where((tech) => Methods.getCompanyFromProfile(tech)?.companyType == "etika")
          .where((tech) => tech.branch?.sId == widget.selectedProfile.branch?.sId)
          .toList();

      setState(() {
        memTechnicians = filtered;
        error = filtered.isEmpty ? "No technicians found from an 'etika' company." : null;
      });
    } catch (e) {
      setState(() {
        error = "Failed to fetch technicians: $e";
        memTechnicians = [];
      });
      log(error!, name: "MemTicketAssignTechDialog");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> save() async {
    if(selectedTechnician == null) {
      setState(() {
        error = "Please select a technician to assign.";
      });
      return;
    }
    setState(() => loading = true);

    try {
      final updatedData = {
        'assignedTechnician': selectedTechnician!.id,
        'status': 'Pending',
        'supervisorEndTime': DateTime.now().toUtc().toIso8601String(),
        'assignedSupervisor': widget.selectedProfile.id,
        'supervisorStartTime': supervisorStartTime.toIso8601String(),
      };

      final Response response = await MemTicketProvider().patchOneAndSave(widget.ticket.id!, updatedData);
      if(response.error == null) {
        if (context.mounted) {
          Navigator.pop(context);
          widget.onUpdated();
        }
      }
    } catch (e) {
      setState(() {
        error = "Failed to assign technician: $e";
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Assign Technician"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<Profile>(
            isExpanded: true,
            initialValue: selectedTechnician,
            decoration: InputDecoration(
              labelText: "Assign to MEM Technician",
              errorText: error,
            ),
            items: memTechnicians.map(
                    (tech) => DropdownMenuItem(
                  value: tech,
                  child: Text(tech.name),
                )
            ).toList(),
            onChanged: loading
                ? null
                : (value) {
              setState(() {
                selectedTechnician = value;
                error = null;
              });
            },
          ),
          if (loading) const Padding(
            padding: EdgeInsets.only(top: 16),
            child: CircularProgressIndicator(),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : widget.onCancel ?? () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton.icon(
          onPressed: loading ? null : save,
          icon: const Icon(Icons.check),
          label: const Text("Assign & Save"),
        )
      ],
    );
  }
}
