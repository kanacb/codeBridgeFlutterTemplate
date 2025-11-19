import 'dart:convert';
import 'dart:developer';

import 'package:aims/App/MenuBottomBar/Profile/Profile.dart';
import 'package:aims/Widgets/IncomingMachineTickets/IncomingMachineTicketProvider.dart';
import 'package:aims/Widgets/JobStationQueues/JobStationInsideQueue.dart';
import 'package:aims/Widgets/JobStationQueues/JobStationQueue.dart';
import 'package:aims/Widgets/JobStationQueues/JobStationQueueProvider.dart';
import 'package:aims/Widgets/JobStationTickets/JobStationTicket.dart';
import 'package:aims/Widgets/JobStationTickets/JobStationTicketProvider.dart';
import 'package:aims/Widgets/JobStations/JobStations.dart';
import 'package:aims/Widgets/JobStations/JobStationsProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../App/MenuBottomBar/Profile/ProfileProvider.dart';
import '../../Utils/Methods.dart';
import '../../Utils/Services/IdName.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/SharedPreferences.dart';
import '../Positions/Positions.dart';
import '../Positions/PositionsProvider.dart';
import '../Users/User.dart';
import 'IncomingMachineTicket.dart';
import 'IncomingMachineTicketPage.dart';
import 'JobStation.dart';

class IncomingTicketAssignJobForm extends StatefulWidget {
  final IncomingMachineTicket incomingTicket;
  final dynamic machine;
  final Profile profile;

  const IncomingTicketAssignJobForm({
    super.key,
    required this.incomingTicket,
    required this.machine,
    required this.profile,
  });

  @override
  State<IncomingTicketAssignJobForm> createState() => _IncomingTicketAssignJobFormState();
}

class _IncomingTicketAssignJobFormState extends State<IncomingTicketAssignJobForm> {
  late IncomingMachineTicket _incomingTicket;
  late dynamic _machine;
  late Profile _profile;
  late User _user;
  List<JobStations> _jobStations = [];
  List<JobStation> _selectedJobStations = [];
  String _error = "";
  bool _loading = false;
  bool _submitting = false;
  List<Profile> _technicians = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _incomingTicket = widget.incomingTicket;
    _machine = widget.machine;
    _profile = widget.profile;
    _user = User.fromJson(jsonDecode(await getPref("user") ?? ""));

    await Future.wait([
      _fetchMachineDetails(),
      _fetchJobStations(),
      _fetchTechnicians(),
    ]);
  }

  Future<void> _fetchMachineDetails() async {
    if (_incomingTicket.machineId == null) return;

    setState(() {
    });
  }

  Future<void> _fetchJobStations() async {
    setState(() {
      _loading = true;
    });

    final jobProvider = Provider.of<JobStationsProvider>(context, listen: false);
    await jobProvider.fetchAllAndSave();

    if (!mounted) return;
    setState(() {
      _jobStations = jobProvider.data;
      _loading = false;
    });
  }

  Future<void> _fetchTechnicians() async {
    setState(() {
      _loading = true;
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
          .where((tech) => tech.branch?.sId == _profile.branch?.sId)
          .toList();

      setState(() {
        _technicians = filtered;
        _error = filtered.isEmpty ? "No technicians found associated with an 'irms' company." : "";
      });
    } catch (e) {
      setState(() {
        _error = "Failed to fetch technicians: $e";
        log(_error, name: "IncomingTicketAssignJobForm");
        _technicians = [];
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  // Helper method to convert JobStations to JobStation
  JobStation _convertJobStationsToJobStation(JobStations jobStations, {String? technicianId}) {
    return JobStation()
      ..name = jobStations.name
      ..technicianId = technicianId != null ? IdName(sId: technicianId, name: _getTechnicianName(technicianId)) : null;
  }

  List<JobStationInsideQueue> _convertToJobStationInsideQueue(List<JobStation> jobStationInTicket) {
    List<JobStationInsideQueue> list = [];

    for (JobStation jobStation in jobStationInTicket) {
      final jobStations = _jobStations.where((station) => station.name == jobStation.name).firstOrNull;

      list.add(JobStationInsideQueue(
        id: jobStations?.id,
        underscoreId: jobStations?.id,
        name: jobStations?.name,
        description: jobStations?.description,
        technicianId: jobStation.technicianId,
      ));
    }

    return list;
  }

  // Helper method to get technician name by ID
  String _getTechnicianName(String technicianId) {
    final technician = _technicians.where(
          (tech) => tech.id == technicianId).firstOrNull;
    return technician?.name ?? 'Unknown';
  }

  Future<void> _onAssign() async {
    if (_selectedJobStations.isEmpty) {
      setState(() {
        _error = "Please select at least one job station.";
      });
      return;
    }

    final unassigned = _selectedJobStations.where((s) => s.technicianId == null).toList();
    if (unassigned.isNotEmpty) {
      setState(() {
        _error = "Please assign a technician to all selected job stations.";
      });
      return;
    }

    if(_incomingTicket.machineService == null || _incomingTicket.machineService!.isEmpty) {
      setState(() {
        _error = "Machine Service in ticket not found. Cannot assign Job Stations";
      });
      return;
    }

    setState(() {
      _submitting = true;
      _error = "";
    });
    try {

      // JobStationTicket create
      final List<JobStationTicket> tickets = [];
      for (int i = 0; i < _selectedJobStations.length; i++) {
        final station = _selectedJobStations[i];

        tickets.add(
          JobStationTicket(
            ticketId: _incomingTicket.id,
            machineId: _incomingTicket.machineId,
            machineService: _incomingTicket.machineService,
            jobStationId: station.name!,
            supervisorId: IdName(sId: _profile.id, name: _profile.name),
            technicianId: station.technicianId,
            status: "Open",
            visibility: i == 0 ? "visible" : "hidden",
            createdBy: IdName(sId: _user.id, name: _user.name),
            updatedBy: IdName(sId: _user.id, name: _user.name),
          ),
        );
      }

      for (JobStationTicket ticket in tickets) {
        final createResponse = await JobStationTicketProvider().createOneAndSave(ticket);
        if (createResponse.error != null) {
          throw Exception(createResponse.error);
        }
      }
      print("all JobStationTicket successfully created");

      // JobStationQueue create
      final JobStationQueue jobStationQueue = JobStationQueue(
        ticketId: _incomingTicket.id,
        machineId: _incomingTicket.machineId,
        machineService: _incomingTicket.machineService,
        jobStations: _convertToJobStationInsideQueue(_selectedJobStations),
        selectedUser: IdName(sId: _user.id, name: _user.name),
      );

      final queueResponse = await JobStationQueueProvider().createOneAndSave(jobStationQueue);
      if (queueResponse.error != null) {
        throw Exception(queueResponse.error);
      }
      print("queue successfully created");

      // IncomingMachineTicket patch
      final updatedData = {
        'status': "In-Progress",
        'selectedJobStations': _selectedJobStations.map((station) => station.toJson()).toList(),
        'assignedSupervisor': _profile.id,
      };

      final patchResponse = await IncomingMachineTicketProvider().patchOneAndSave(_incomingTicket.id!, updatedData);
      if (patchResponse.error == null) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => IncomingMachineTicketPage(
                successMessage: "Ticket assigned successfully!",
              ),
            ),
          );
        }
      }

    } catch (e) {
      setState(() {
        _error = "Failed to assign job stations: ${e.toString()}";
      });
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_submitting, // if loading, prevent pop
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _submitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please wait, submitting ticket..."),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Assign Job Stations'),
              backgroundColor: Colors.white,
              elevation: 1,
              titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _loading ? null : _onAssign,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: _loading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text("SUBMIT"),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Machine Serial Number
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.precision_manufacturing, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Serial No: ${_machine.serialNumber ?? "-"}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Main content
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Use different layouts based on screen width
                        if (constraints.maxWidth > 800) {
                          // Desktop/Tablet layout - 3 columns
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: _buildJobStationSelection()),
                              SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildSelectedJobStations()),
                              SizedBox(width: 16),
                              Expanded(flex: 3, child: _buildTechnicianAssignment()),
                            ],
                          );
                        } else {
                          // Mobile layout - single column with tabs
                          return DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                TabBar(
                                  labelColor: Colors.blue,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: [
                                    Tab(text: 'Select'),
                                    Tab(text: 'Order'),
                                    Tab(text: 'Assign'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _buildJobStationSelection(),
                                      _buildSelectedJobStations(),
                                      _buildTechnicianAssignment(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // Error message
                  if (_error.isNotEmpty) ...[
                    Card(
                      color: Colors.red[50],
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Overlay on top of Scaffold
          if (_submitting)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ]
      ),
    );
  }

  Widget _buildJobStationSelection() {
    return SafeArea(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Job Stations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _jobStations.length,
                  itemBuilder: (context, index) {
                    final station = _jobStations[index];
                    final isSelected = _selectedJobStations
                        .any((s) => s.name == station.name);

                    return CheckboxListTile(
                      title: Text(station.name),
                      subtitle: station.description.isNotEmpty
                          ? Text(station.description)
                          : null,
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedJobStations.add(_convertJobStationsToJobStation(station));
                          } else {
                            _selectedJobStations.removeWhere(
                                    (s) => s.name == station.name);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedJobStations() {
    return SafeArea(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Job Stations (${_selectedJobStations.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: _selectedJobStations.isEmpty
                    ? Center(
                  child: Text(
                    'No job stations selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ReorderableListView.builder(
                  itemCount: _selectedJobStations.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = _selectedJobStations.removeAt(oldIndex);
                      _selectedJobStations.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final station = _selectedJobStations[index];
                    final assignedTechnician = station.technicianId?.name ?? 'Unassigned';

                    return Card(
                      key: ValueKey('${station.name}_$index'),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                          backgroundColor: station.technicianId != null
                              ? Colors.green
                              : Colors.grey,
                        ),
                        title: Text(
                          station.name ?? 'Unknown',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Technician: $assignedTechnician',
                              style: TextStyle(
                                fontSize: 12,
                                color: station.technicianId != null
                                    ? Colors.green[600]
                                    : Colors.red[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.drag_handle),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicianAssignment() {
    return SafeArea(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assign Technicians',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),

              Expanded(
                child: _selectedJobStations.isEmpty
                    ? Center(
                  child: Text(
                    'No job stations selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: _selectedJobStations.length,
                  itemBuilder: (context, index) {
                    final station = _selectedJobStations[index];
                    final assignedTechId = station.technicianId?.sId ?? '';

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              station.name ?? 'Unknown',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: assignedTechId.isEmpty ? null : assignedTechId,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Select Technician',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              items: _technicians.map((tech) {
                                return DropdownMenuItem<String>(
                                  value: tech.id,
                                  child: Text(
                                    tech.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: _loading || _technicians.isEmpty
                                  ? null
                                  : (String? value) {
                                setState(() {
                                  if (value != null) {
                                    _selectedJobStations[index].technicianId =
                                        IdName(sId: value, name: _getTechnicianName(value));
                                  } else {
                                    _selectedJobStations[index].technicianId = null;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}