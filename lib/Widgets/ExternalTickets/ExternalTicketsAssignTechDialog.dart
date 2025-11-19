import 'dart:developer';

import 'package:aims/App/MenuBottomBar/Profile/Profile.dart';
import 'package:aims/App/MenuBottomBar/Profile/ProfileProvider.dart';
import 'package:flutter/material.dart';

import '../../Utils/Methods.dart';
import '../../Utils/Services/Response.dart';
import '../Positions/Positions.dart';
import '../Positions/PositionsProvider.dart';
import 'ExternalTickets.dart';
import 'ExternalTicketsProvider.dart';

class ExternalTicketsAssignTechDialog extends StatefulWidget {
  final ExternalTickets ticket;
  final Profile selectedProfile;
  final VoidCallback onUpdated;
  final VoidCallback? onCancel;

  const ExternalTicketsAssignTechDialog({
    super.key,
    required this.ticket,
    required this.selectedProfile,
    required this.onUpdated,
    this.onCancel,
  });

  @override
  State<ExternalTicketsAssignTechDialog> createState() => _ExternalTicketsAssignTechDialogState();
}

class _ExternalTicketsAssignTechDialogState extends State<ExternalTicketsAssignTechDialog> {
  List<Profile> _technicians = [];
  Profile? _selectedTechnician;
  bool _loading = false;
  String? _error;

  late DateTime supervisorStartTime;

  @override
  void initState() {
    super.initState();
    supervisorStartTime = DateTime.now().toUtc();
    fetchTechnicians();
  }

  Future<void> fetchTechnicians() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Fetch all technician profiles by position ID
      final Response responsePosition = await PositionsProvider().fetchByNameAndSave("Technician");
      List<Positions> positions = responsePosition.data;

      final Response responseProfile = await ProfileProvider().find("position", positions[0].id!);
      if (responseProfile.error != null) {
        setState(() {
          _error = "Error fetching technician profiles: ${responseProfile.error}";
          _technicians = [];
        });
        return;
      }

      final List<Profile>? unfilteredTechnicians = responseProfile.data;
      if (unfilteredTechnicians == null || unfilteredTechnicians.isEmpty) {
        setState(() {
          _error = "No technicians found";
          _technicians = [];
        });
        return;
      }

      // Filter technicians by companyType == 'irms' and by Supervisor's branch
      final List<Profile> filtered = unfilteredTechnicians
          .where((tech) => Methods.getCompanyFromProfile(tech)?.companyType == "irms")
          .where((tech) => tech.branch?.sId == widget.selectedProfile.branch?.sId)
          .toList();

      setState(() {
        _technicians = filtered;
        _error = filtered.isEmpty ? "No suitable technicians found" : null;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to fetch technicians: $e";
        _technicians = [];
      });
      log(_error!, name: "ExternalTicketsAssignTechDialog");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> save() async {
    if(_selectedTechnician == null) {
      setState(() {
        _error = "Please select a technician to assign.";
      });
      return;
    }
    setState(() => _loading = true);

    try {
      final updatedData = {
        'assignedTechnician': _selectedTechnician!.id,
        'status': 'Pending',
        'supervisorEndTime': DateTime.now().toUtc().toIso8601String(),
        'assignedSupervisor': widget.selectedProfile.id,
        'supervisorStartTime': supervisorStartTime.toIso8601String(),
      };

      final Response response = await ExternalTicketsProvider().patchOneAndSave(widget.ticket.id!, updatedData);
      if(response.error == null) {
        if (context.mounted) {
          Navigator.pop(context);
          widget.onUpdated();
        }
      }
    } catch (e) {
      setState(() {
        _error = "Failed to assign technician: $e";
      });
    } finally {
      setState(() => _loading = false);
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
            initialValue: _selectedTechnician,
            decoration: InputDecoration(
              labelText: "Assign to a technician",
              errorText: _error,
            ),
            items: _technicians.map(
                    (tech) => DropdownMenuItem(
                  value: tech,
                  child: Text(tech.name),
                )
            ).toList(),
            onChanged: _loading
                ? null
                : (value) {
              setState(() {
                _selectedTechnician = value;
                _error = null;
              });
            },
          ),
          if (_loading) const Padding(
            padding: EdgeInsets.only(top: 16),
            child: CircularProgressIndicator(),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : widget.onCancel ?? () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton.icon(
          onPressed: _loading ? null : save,
          icon: const Icon(Icons.check),
          label: const Text("Assign & Save"),
        )
      ],
    );
  }
}
