import 'package:aims/Widgets/AtlasMachines/AtlasMachinesProvider.dart';
import 'package:aims/Widgets/ExternalMachines/ExternalMachinesProvider.dart';
import 'package:aims/Widgets/IrmsMachines/IrmsMachinesProvider.dart';
import 'package:aims/Widgets/MemMachines/MemMachinesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Globals.dart' as globals;
import '../../Utils/Dialogs/BottomNavigationBar.dart';
import '../../Utils/Dialogs/DeleteDialog.dart';
import '../../Utils/Dialogs/DrawerMenu.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/Methods.dart';
import '../../Utils/PageUtils.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/ServiceFilterByMenu.dart';
import '../../Utils/Services/ServiceFieldsMenu.dart';
import '../../Utils/Services/ServiceSortByMenu.dart';
import '../../Utils/Services/ServiceMoreMenu.dart';
import 'JobStationTicket.dart';
import 'JobStationTicketProvider.dart';
import 'JobStationTicketTechCloseDialog.dart';
import 'JobStationTicketTechOpenDialog.dart';
import 'SingleJobStationTicketPage.dart';

class JobStationTicketList extends StatefulWidget {
  final String? successMessage;

  const JobStationTicketList({super.key, this.successMessage});

  @override
  State<JobStationTicketList> createState() => _JobStationTicketListState();
}

class _JobStationTicketListState extends State<JobStationTicketList> {
  final Logger logger = globals.logger;
  final Utils utils = Utils();
  Profile? _profile;
  List<JobStationTicket>? _jobStationTickets;
  List<dynamic>? _incomingMachines;

  bool _loading = false;

  bool _showMenu = false;
  bool _showFilterBy = false;
  bool _showFields = false;
  bool _showSort = false;

  final List<bool> _showMore = List.filled(200, false, growable: true);
  List<bool> _selected = List.filled(200, false, growable: true);
  bool _allSelected = false;

  Response? schemaResponse;

  @override
  void initState() {
    super.initState();
    _fetchSchema();
    _initialize();

    if(widget.successMessage != null) _showSuccessMessage(widget.successMessage!);
  }

  Future<void> _initialize() async {
    // this ensures profile is loaded first before tickets can handle profile
    await _loadSelectedProfile();
    await _loadTickets();
  }

  Future<void> _loadSelectedProfile() async {
    _profile = await Methods.loadSelectedProfile();
  }

  Future<void> _loadTickets() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });

    final ticketProvider = Provider.of<JobStationTicketProvider>(context, listen: false);
    await ticketProvider.fetchAllAndSave();

    final result = await _filterTickets(
      unfilteredTickets: ticketProvider.data,
      selectedProfilePosition: _profile?.position?.name ?? "",
      selectedProfileId: _profile?.id ?? "",
    );
    if (!mounted) return;

    setState(() {
      _jobStationTickets = result.reversed.toList(); // make latest ticket top first
      _loading = false;
    });
    print("DEBUG JobStationTicketList - tickets: ${_jobStationTickets!.length}");
  }

  Future<void> _fetchSchema() async {
    await JobStationTicketProvider().fetchAllAndSave();
    schemaResponse = await JobStationTicketProvider().schema();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _deleteTicket(String id, bool confirm) async {
    if (confirm) {
      final provider = Provider.of<JobStationTicketProvider>(context, listen: false);
      Response response = await provider.deleteOne(id);

      if (response.isSuccess) {
        await _loadTickets();
        _showSuccessMessage("Deleted ticket successfully");
      } else {
        _showNoticeMessage("Failed to delete ticket");
      }
    }
  }

  Future<List<JobStationTicket>> _filterTickets({
    required List<JobStationTicket> unfilteredTickets,
    required String selectedProfilePosition,
    required String selectedProfileId,
  }) async {
    List<JobStationTicket> filteredTickets = unfilteredTickets;
    await _loadIncomingMachines(unfilteredTickets);

    if (!mounted) return [];

    switch(selectedProfilePosition) {
      case "Super":
      case "Admin":
      // show all data
        break;
      case "Technician":
        filteredTickets = _filterForTechnician(unfilteredTickets, selectedProfileId);
        break;
      default:
      // unknown role - return empty
        print("IncomingMachineTicketList: unknown role: $selectedProfilePosition");
        filteredTickets = [];
    }

    return filteredTickets;
  }

  List<JobStationTicket> _filterForTechnician(List<JobStationTicket> tickets, String selectedProfileId) {
    return tickets.where((ticket) {
      return ticket.technicianId?.sId == selectedProfileId && ticket.visibility != "hidden";
    }).toList();
  }

  Future<void> _loadIncomingMachines(List<JobStationTicket> tickets) async {
    final irmsMachinesProvider = Provider.of<IrmsMachinesProvider>(context, listen: false);
    final atlasMachinesProvider = Provider.of<AtlasMachinesProvider>(context, listen: false);
    final memMachinesProvider = Provider.of<MemMachinesProvider>(context, listen: false);
    final externalMachinesProvider = Provider.of<ExternalMachinesProvider>(context, listen: false);

    List<Future<void>> futures = tickets.map((ticket) async {
      try {
        Response response = await irmsMachinesProvider.fetchOneAndSave(ticket.machineId!);
        if (response.data == null) {
          response = await atlasMachinesProvider.fetchOneAndSave(ticket.machineId!);
        }
        if (response.data == null) {
          response = await memMachinesProvider.fetchOneAndSave(ticket.machineId!);
        }
        if (response.data == null) {
          response = await externalMachinesProvider.fetchOneAndSave(ticket.machineId!);
        }
        if(response.error != null) print("failed fetching incoming machine: ${response.error}");
        //print("_loadAtlasMachines ${response.data}");
      } catch (e) {
        print("ERROR _loadIncomingMachines $e");
      }
    }).toList();

    await Future.wait(futures);

    _incomingMachines = [
      ...irmsMachinesProvider.data,
      ...atlasMachinesProvider.data,
      ...memMachinesProvider.data,
      ...externalMachinesProvider.data,
    ];
  }

  void _showSuccessMessage(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green,),
      );
    });
  }

  void _showNoticeMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerMenu(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
        onTap: () => setState(() {
          _showMenu = false;
          _showFilterBy = false;
          _showFields = false;
          _showSort = false;
        }),
        child: Stack(
          children: [
            Column(
              children: [
                // Always show the header
                // _buildHeader(),

                // Show "No tickets" or the ticket list
                _jobStationTickets == null || _jobStationTickets!.isEmpty
                    ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.confirmation_num_outlined, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text("No tickets available", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    )
                )
                    : Expanded(
                  child: _buildTicketList(_jobStationTickets!),
                ),
              ],
            ),
            ServiceMoreMenu(show: _showMenu),
            ServiceFilterByMenu(show: _showFilterBy, response: schemaResponse?.data),
            ServiceSortByMenu(show: _showSort, response: schemaResponse?.data),
            ServiceFieldsMenu(show: _showFields, response: schemaResponse?.data),
          ],
        ),
      ),
      bottomNavigationBar: CBBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Job Station Ticket Management'),
      backgroundColor: Colors.white,
      elevation: 1,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      // actions: [
      //   IconButton(
      //     icon: _showMenu
      //         ? const Icon(Icons.close_rounded)
      //         : const Icon(Icons.more_horiz_rounded),
      //     onPressed: () => setState(() {
      //       _showMenu = !_showMenu;
      //     }),
      //   ),
      // ],
    );
  }

  Widget _buildTicketList(List<JobStationTicket> tickets) {
    return ListView.builder(
      itemCount: tickets.length + 1, // Header + List Items
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader();
        final ticket = tickets[index - 1];

        return _buildTicketCard(ticket, index - 1);
      },
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Checkbox(
          //   value: _allSelected,
          //   onChanged: (value) {
          //     setState(() {
          //       _allSelected = value!;
          //       _selected = List<bool>.filled(200, _allSelected, growable: true);
          //     });
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.filter_list, color: _showFilterBy ? Colors.red : Colors.grey),
          //   onPressed: () => setState(() => _showFilterBy = !_showFilterBy),
          // ),
          // IconButton(
          //   icon: Icon(Icons.sort, color: _showSort ? Colors.red : Colors.grey),
          //   onPressed: () => setState(() => _showSort = !_showSort),
          // ),
          // IconButton(
          //   icon: Icon(Icons.list, color: _showFields ? Colors.red : Colors.grey),
          //   onPressed: () => setState(() => _showFields = !_showFields),
          // ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(JobStationTicket ticket, int index) {
    final incomingMachine = _incomingMachines
        ?.where((m) => m.id == ticket.machineId)
        .firstOrNull;
    final selectedProfilePosition = _profile?.position?.name;
    bool hasAccess = selectedProfilePosition == "Admin" || selectedProfilePosition == "Super";
    final statusColor = _getStatusColor(ticket.status);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SingleJobStationTicketPage(
                ticket: ticket,
                machine: incomingMachine,
                profile: _profile!,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Serial No: ${incomingMachine?.serialNumber ?? "-"}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ticket.jobStationId ?? "-",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${ticket.status}",
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // MACHINE INFO
              Row(
                children: [
                  const Icon(Icons.settings, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Model: ${incomingMachine?.modelNo ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Ownership: ${incomingMachine?.ownership.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.category, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Type: ${incomingMachine?.vendingMachineType?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.supervisor_account, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Supervisor: ${ticket.supervisorId?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Technician: ${ticket.technicianId?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.play_arrow, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Start: ${Methods.formatDateTime(ticket.startTime)}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.stop, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("End: ${Methods.formatDateTime(ticket.endTime, fallback: "In-Progress")}")),
                ],
              ),

              // Show more content
              _buildShowMoreContent(ticket, index),

              // Show More / Show Less button
              TextButton(
                onPressed: () => setState(() => _showMore[index] = !_showMore[index]),
                child: Text(
                  _showMore[index] ? 'Show less' : 'Show more',
                  style: const TextStyle(color: Colors.red),
                ),
              ),

              const Divider(height: 30),

              // ACTIONS
              Align(
                alignment: Alignment.centerRight,
                child: (!hasAccess)
                    ? _buildActions(ticket, incomingMachine)
                    : _editDeleteButtons(ticket),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Open': return Colors.orange;
      case 'In Progress': return Colors.blue;
      case 'In-Progress': return Colors.blue;
      case 'Aborted': return Colors.red;
      case 'Closed':
      case 'Resolved': return Colors.green;
      case 'Not Started': return Colors.grey;
      default: return Colors.grey;
    }
  }

  Widget _buildShowMoreContent(JobStationTicket ticket, int index) {
    if (!_showMore[index]) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Expanded(child: Text("Incoming Remarks: ${ticket.incomingRemarks ?? "-"}")),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.play_arrow, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Expanded(child: Text("Closing Remarks: ${ticket.jobCarriedOut ?? "-"}")),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(JobStationTicket ticket, dynamic incomingMachine) {
    List<Widget> actions = [];
    final selectedProfilePosition = _profile?.position?.name;

    if (selectedProfilePosition == "Technician" && ticket.status == "Open") {
      actions.add(
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) => JobStationTicketTechOpenDialog(
                  ticket: ticket,
                  machine: incomingMachine,
                  onUpdated: () async {
                    await _loadTickets();
                    _showSuccessMessage("Ticket opened successfully");
                  },
                  onHide: () {Navigator.of(dialogContext).pop();},
                ),
              );
            },
            child: Text("Open", style: TextStyle(color: Colors.white))
        ),
      );
    }

    if (selectedProfilePosition == "Technician" && ticket.status == "In Progress") {
      actions.add(
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) => JobStationTicketTechCloseDialog(
                  ticket: ticket,
                  machine: incomingMachine,
                  onUpdated: () async {
                    await _loadTickets();
                    _showSuccessMessage("Ticket closed successfully");
                  },
                  onHide: () {Navigator.of(dialogContext).pop();},
                ),
              );
            },
            child: Text("Close", style: TextStyle(color: Colors.white))
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: actions,
    );
  }

  Widget _editDeleteButtons(JobStationTicket ticket) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (context) => DeleteDialog(
                title: "Delete Ticket",
                content: "Are you sure?",
                pos: "Yes",
                neg: "Cancel",
                id: ticket.id!,
                answer: (id, answerBool) => _deleteTicket(id, answerBool),
              ),
            );
          },
        ),
      ],
    );
  }
}
