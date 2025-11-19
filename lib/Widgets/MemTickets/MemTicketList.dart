import 'package:aims/App/MenuBottomBar/Profile/ProfileProvider.dart';
import 'package:aims/Widgets/Companies/Companies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Globals.dart' as globals;
import '../../Utils/Dialogs/BottomNavigationBar.dart';
import '../../Utils/Dialogs/DeleteDialog.dart';
import '../../Utils/Dialogs/DrawerMenu.dart';
import '../../Utils/Methods.dart';
import '../../Utils/PageUtils.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/ServiceFilterByMenu.dart';
import '../../Utils/Services/ServiceFieldsMenu.dart';
import '../../Utils/Services/ServiceSortByMenu.dart';
import '../../Utils/Services/ServiceMoreMenu.dart';
import '../MemMachines/MemMachines.dart';
import '../MemMachines/MemMachinesProvider.dart';
import '../RaiseTicket/QrCodeScanner.dart';
import 'MemTicket.dart';
import 'MemTicketAbortDialog.dart';
import 'MemTicketAssignTechDialog.dart';
import 'MemTicketProvider.dart';
import 'MemTicketTechCloseDialog.dart';
import 'MemTicketTechOpenDialog.dart';
import 'ReopenMemTicket.dart';
import 'SingleMemTicketPage.dart';

class MemTicketList extends StatefulWidget {
  final String? successMessage;

  const MemTicketList({super.key, this.successMessage});

  @override
  State<MemTicketList> createState() => _MemTicketListState();
}

class _MemTicketListState extends State<MemTicketList> {
  final Logger logger = globals.logger;
  final Utils utils = Utils();
  Profile? profile;
  List<MemTicket>? filteredTickets;
  List<MemMachines>? memMachines;

  bool _loading = false;
  bool _showAssignedOnly = false;


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
    profile = await Methods.loadSelectedProfile();
  }

  Future<void> _loadTickets() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });

    final ticketProvider = Provider.of<MemTicketProvider>(context, listen: false);
    await ticketProvider.fetchAllAndSave();

    final result = await filterTickets(
      unfilteredTickets: ticketProvider.data,
      selectedProfilePosition: profile?.position?.name ?? "",
      selectedProfileId: profile?.id ?? "",
    );
    if (!mounted) return;
    setState(() {
      filteredTickets = result.reversed.toList(); // make latest ticket top first
      _loading = false;
    });
    print("DEBUG MemTicketList - tickets: ${filteredTickets!.length}");
  }

  Future<void> _fetchSchema() async {
    await MemTicketProvider().fetchAllAndSave();
    schemaResponse = await MemTicketProvider().schema();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _deleteTicket(String id, bool confirm) async {
    if (confirm) {
      final provider = Provider.of<MemTicketProvider>(context, listen: false);
      Response response = await provider.deleteOne(id);

      if (response.isSuccess) {
        await _loadTickets();
        _showSuccessMessage("Deleted ticket successfully");
      } else {
        _showNoticeMessage("Failed to delete ticket");
      }
    }
  }

  Future<List<MemTicket>> filterTickets({
    required List<MemTicket> unfilteredTickets,
    required String selectedProfilePosition,
    required String selectedProfileId,
  }) async {
    List<MemTicket> filteredTickets = unfilteredTickets;
    await _loadMemMachines(unfilteredTickets);

    if (!mounted) return [];
    //log(memMachines.toString(), name: "provider is working");

    switch(selectedProfilePosition) {
      case "Super":
      case "Admin":
      // show all data
        break;
      case "Supervisor":
        filteredTickets = await _filterForSupervisor(unfilteredTickets, selectedProfileId);
        break;
      case "Technician":
        filteredTickets = unfilteredTickets.where((ticket) => ticket.assignedTechnician?.sId == selectedProfileId).toList();
        break;
      case "Salesman":
        filteredTickets = unfilteredTickets.where((ticket) => ticket.salesman?.sId == selectedProfileId).toList();
        break;
      default:
      // unknown role - return empty
        print("MemTicketList: unknown role: $selectedProfilePosition");
        filteredTickets = [];
    }

    // Apply assigned-only filter if toggle is enabled
    if (_showAssignedOnly) {
      filteredTickets = _applyAssignedOnlyFilter(filteredTickets, selectedProfilePosition, selectedProfileId);
    }

    return filteredTickets;
  }

  List<MemTicket> _applyAssignedOnlyFilter(
      List<MemTicket> tickets,
      String selectedProfilePosition,
      String currentUserId,
      ) {
    if (selectedProfilePosition == "Supervisor") {
      return tickets.where((ticket) => ticket.assignedSupervisor?.sId == currentUserId).toList();
    }
    // For other roles, return all tickets (no additional filtering)
    return tickets;
  }

  void _toggleAssignedOnlyFilter() {
    setState(() {
      _showAssignedOnly = !_showAssignedOnly;
    });
    // Reload tickets with new filter
    _loadTickets();
  }

  Future<List<MemTicket>> _filterForSupervisor(List<MemTicket> tickets, String selectedProfileId) async {
    //create a list of futures for parallel processing
    List<Future<bool>> filterFutures = tickets.map((ticket) async {
      if (ticket.status == "Open") {
        return await _canSupervisorSeeOpenTicket(ticket);
      } else {
        // for non-open ticket, check if profile is assigned supervisor
        if (ticket.assignedSupervisor?.sId == selectedProfileId) {
          return true;
        }
        // else check if assigned supervisor is from the same branch
        return await _isAssignedSupervisorSameBranch(ticket);
      }
    }).toList();

    // wait for all filtering decisions
    List<bool> results = await Future.wait(filterFutures);

    // filter items based on results
    List<MemTicket> filteredTickets = [];
    for(int i=0; i < tickets.length; i++) {
      if (results[i]) {
        filteredTickets.add(tickets[i]);
      }
    }

    return filteredTickets;
  }

  Future<bool> _canSupervisorSeeOpenTicket(MemTicket ticket) async {
    try {
      // get salesman profile of each ticket
      Profile? salesmanProfile;

      if (ticket.salesman == null) return false;

      final Response response = await ProfileProvider().fetchOneAndSave(ticket.salesman!.sId!);
      if (response.error == null) salesmanProfile = response.data;
      if (salesmanProfile == null) return false;

      //get selected profile's company info
      Companies? selectedProfileCompany;
      if (profile?.company != null) {
        selectedProfileCompany = Methods.getCompanyFromProfile(profile!);
      }

      // check all conditions
      return profile?.branch?.sId == salesmanProfile.branch?.sId && selectedProfileCompany?.companyType == "etika";
    } catch (e) {
      print("ERROR checking supervisor permissions: $e");
      return false;
    }
  }

  Future<bool> _isAssignedSupervisorSameBranch(MemTicket ticket) async {
    try {
      if (ticket.assignedSupervisor == null || profile?.branch?.sId == null) {
        return false;
      }

      // Fetch the assigned supervisor's profile
      final Response response = await ProfileProvider().fetchOneAndSave(ticket.assignedSupervisor!.sId!);
      if (response.error != null) return false;

      Profile? assignedSupervisorProfile = response.data;
      if (assignedSupervisorProfile == null) return false;

      // Check if both supervisors are from the same branch
      return profile?.branch?.sId == assignedSupervisorProfile.branch?.sId;
    } catch (e) {
      print("ERROR checking assigned supervisor branch: $e");
      return false;
    }
  }

  Future<void> _loadMemMachines(List<MemTicket> tickets) async {
    final memMachinesProvider = Provider.of<MemMachinesProvider>(context, listen: false);
    List<Future<void>> futures = tickets.map((ticket) async {
      try {
        final Response response = await memMachinesProvider.fetchOneAndSave(ticket.machineId!);
        if(response.error != null) print("failed fetching mem machine: ${response.error}");
      } catch (e) {
        print("ERROR _loadMemMachines $e");
      }
    }).toList();

    await Future.wait(futures);

    memMachines = memMachinesProvider.data;
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
                filteredTickets == null || filteredTickets!.isEmpty
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
                  child: _buildTicketList(filteredTickets!),
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
      floatingActionButton: (profile?.position?.name == "Admin" ||
          profile?.position?.name == "Super" ||
          profile?.position?.name == "Salesman" ||
          profile?.position?.name == "Supervisor")
          ? FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const QrCodeScanner(companyType: "etika",),
            ),
          );
        },
      )
          : null, // no FAB for other roles
      bottomNavigationBar: CBBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Mem Ticket Management'),
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

  Widget _buildTicketList(List<MemTicket> tickets) {
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
    final selectedProfilePosition = profile?.position?.name ?? "";
    final showFilterButton = selectedProfilePosition == "Supervisor" || selectedProfilePosition == "Incomingmachinechecker";

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (showFilterButton)
            Row(
              children: [
                Icon(
                  _showAssignedOnly ? Icons.person : Icons.group,
                  size: 16,
                  color: _showAssignedOnly ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: _toggleAssignedOnlyFilter,
                  child: Text(
                    _showAssignedOnly ? 'My Tickets' : 'All Tickets',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _showAssignedOnly ? Colors.red : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            )
          else
            const SizedBox.shrink(),

          // todo implement the filter and remove this placeholder
          const SizedBox(height: 50, width: 40,),
          const SizedBox(height: 50, width: 40,),
          const SizedBox(height: 50, width: 40,),
          const SizedBox(height: 50, width: 40,),

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

  Widget _buildTicketCard(MemTicket ticket, int index) {
    final memMachine = memMachines
        ?.where((m) => m.id == ticket.machineId)
        .cast<MemMachines?>()
        .firstOrNull;

    final selectedProfilePosition = profile?.position?.name;
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
              builder: (_) => SingleMemTicketPage(ticket: ticket, machine: memMachine),
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
                    child: Text("Serial No: ${memMachine?.serialNumber ?? "-"}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
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

              const SizedBox(height: 8),

              // MACHINE INFO
              Row(
                children: [
                  const Icon(Icons.settings, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Model: ${memMachine?.modelNo ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Ownership: ${memMachine?.ownership.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.category, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Type: ${memMachine?.vendingMachineType?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.memory, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Salesman: ${ticket.salesman?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.supervisor_account, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Supervisor: ${ticket.assignedSupervisor?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Technician: ${ticket.assignedTechnician?.name ?? "-"}")),
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
                    ? _buildActions(ticket, memMachine)
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
      case "Open": return Colors.blue;
      case "Pending": return Colors.orange;
      case "In-Progress": return Colors.red;
      case "Repaired":
      case "Closed": return Colors.green;
      case "Aborted": return Colors.grey;
      default: return Colors.black;
    }
  }

  Widget _buildShowMoreContent(MemTicket ticket, int index) {
    final checklist = ticket.checklistResponse;

    if (!_showMore[index] || checklist == null || checklist.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CHECKLIST RESPONSE
          const Text(
            'Checklist Response',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          ...checklist.map(
                (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.black87, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(MemTicket ticket, MemMachines? machine) {
    List<Widget> actions = [];
    final selectedProfilePosition = profile?.position?.name;
    final selectedProfileId = profile?.id ?? "";

    bool canTakeActions = ticket.assignedSupervisor?.sId == selectedProfileId || ticket.status == "Open";

    if (selectedProfilePosition == "Supervisor" && ticket.status == "Open" && canTakeActions) {
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
                builder: (_) => MemTicketAssignTechDialog(
                  ticket: ticket,
                  selectedProfile: profile!,
                  onUpdated: () async {
                    await _loadTickets();
                    _showSuccessMessage("Technician assigned successfully!");
                  },
                ),
              );
            },
            child: Text("Open", style: TextStyle(color: Colors.white))
        ),
      );
    }

    if (selectedProfilePosition == "Technician" && ticket.status == "Pending") {
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
                builder: (BuildContext dialogContext) => MemTicketTechOpenDialog(
                  ticket: ticket,
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

    if (selectedProfilePosition == "Technician" && ticket.status == "In-Progress") {
      actions.add(
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              if (machine == null) {
                _showNoticeMessage("Cannot close ticket: no machine linked.");
                return;
              }
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) => MemTicketTechCloseDialog(
                  ticket: ticket,
                  machine: machine,
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

    if (selectedProfilePosition == "Supervisor" && ticket.status == "In-Progress" && canTakeActions) {
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
                builder: (BuildContext dialogContext) => MemTicketAbortDialog(
                  ticket: ticket,
                  onUpdated: () async {
                    await _loadTickets();
                    _showSuccessMessage("Ticket aborted successfully");
                  },
                  onHide: () {Navigator.of(dialogContext).pop();},
                ),
              );
            },
            child: Text("Abort", style: TextStyle(color: Colors.white))
        ),
      );
    }

    if (selectedProfilePosition == "Supervisor" &&
        (ticket.status == "Aborted" || ticket.status == "Repaired" ||
            ticket.status == "Incomplete") && canTakeActions) {
      actions.add(
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              if (machine == null) {
                _showNoticeMessage("Cannot reopen ticket: no machine linked.");
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => ReopenMemTicket(
                    oldTicket: ticket,
                    newVC: profile!,
                  ),
                ),
              );
            },
            child: Text("Reopen", style: TextStyle(color: Colors.white))
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: actions,
    );
  }

  Widget _editDeleteButtons(MemTicket ticket) {
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
