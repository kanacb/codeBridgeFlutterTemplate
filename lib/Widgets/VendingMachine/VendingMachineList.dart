import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../Utils/Globals.dart' as globals;
import '../../Utils/Dialogs/BottomNavigationBar.dart';
import '../../Utils/Dialogs/DeleteDialog.dart';
import '../../Utils/Dialogs/DrawerMenu.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/ServiceFilterByMenu.dart';
import '../../Utils/Services/ServiceFieldsMenu.dart';
import '../../Utils/Services/ServiceSortByMenu.dart';
import '../../Utils/Services/ServiceMoreMenu.dart';
import 'VendingMachine.dart';
import 'VendingMachineAdd.dart';
import 'VendingMachineEdit.dart';
import 'VendingMachineProvider.dart';

class VendingMachineList extends StatefulWidget {
  const VendingMachineList({super.key});

  @override
  State<VendingMachineList> createState() => _VendingMachineListState();
}

class _VendingMachineListState extends State<VendingMachineList> {
  final Logger logger = globals.logger;
  final Utils utils = Utils();

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
  }

  Future<void> _fetchSchema() async {
    schemaResponse = await VendingMachineProvider().schema();
    await VendingMachineProvider().fetchAllAndSave();
    setState(() {});
  }

  Future<void> _deleteMachine(String id, bool confirm) async {
    if (confirm) {
      final provider =
          Provider.of<VendingMachineProvider>(context, listen: false);
      Response response = await provider.deleteOne(id);

      if (response.isSuccess) {
        SnackBars().SuccessSnackBar(context, "Deleted machine successfully");
        setState(() {
          provider.loadVendingMachineFromHive(); // Refresh the data
        });
      } else {
        SnackBars().FailedSnackBar(context, "Failed to delete machine");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final machineProvider =
        Provider.of<VendingMachineProvider>(context, listen: false);
    List<VendingMachine> machines = machineProvider.data.toList();
    print("Machine List Length: ${machines.length}");

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerMenu(),
      body: machineProvider.isLoading
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
                      _buildHeader(),

                      // Show "No machines" or the machine list
                      machines.isEmpty
                          ? const Expanded(
                              child: Center(
                                child: Text('No machines available'),
                              ),
                            )
                          : Expanded(
                              child: _buildMachineList(machines),
                            ),
                    ],
                  ),
                  ServiceMoreMenu(show: _showMenu),
                  ServiceFilterByMenu(
                      show: _showFilterBy, response: schemaResponse?.data),
                  ServiceSortByMenu(
                      show: _showSort, response: schemaResponse?.data),
                  ServiceFieldsMenu(
                      show: _showFields, response: schemaResponse?.data),
                ],
              ),
            ),
      bottomNavigationBar: CBBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Machine Master Data'),
      backgroundColor: Colors.white,
      elevation: 1,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        IconButton(
          icon: _showMenu
              ? const Icon(Icons.close_rounded)
              : const Icon(Icons.more_horiz_rounded),
          onPressed: () => setState(() {
            _showMenu = !_showMenu;
          }),
        ),
      ],
    );
  }

  Widget _buildMachineList(List<VendingMachine> machines) {
    return ListView.builder(
      itemCount: machines.length + 1, // Header + List Items
      itemBuilder: (context, index) {
        if (index == 0)
          return const SizedBox.shrink(); // Header already displayed
        final machine = machines[index - 1];
        return _buildMachineCard(machine, index - 1);
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
          Checkbox(
            value: _allSelected,
            onChanged: (value) {
              setState(() {
                _allSelected = value!;
                _selected =
                    List<bool>.filled(200, _allSelected, growable: true);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list,
                color: _showFilterBy ? Colors.red : Colors.grey),
            onPressed: () => setState(() => _showFilterBy = !_showFilterBy),
          ),
          IconButton(
            icon: Icon(Icons.sort, color: _showSort ? Colors.red : Colors.grey),
            onPressed: () => setState(() => _showSort = !_showSort),
          ),
          IconButton(
            icon:
                Icon(Icons.list, color: _showFields ? Colors.red : Colors.grey),
            onPressed: () => setState(() => _showFields = !_showFields),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(utils.createRoute(
                  context, VendingMachineAdd(resource: schemaResponse?.data)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineCard(VendingMachine vm, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      child: Column(
        children: [
          ListTile(
            minVerticalPadding: 2.0,
            minTileHeight: 2.0,
            leading: Checkbox(
              splashRadius: 1.0,
              value: _selected[index],
              onChanged: (value) => setState(() => _selected[index] = value!),
            ),
            title: Text(
              vm.name!.substring(0, 10).padRight(11," ..."),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  iconSize: 17.0,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).push(utils.createRoute(
                        context,
                        VendingMachineEdit(
                          resource: schemaResponse?.data,
                          vm: vm,
                        )));
                  },
                ),
                IconButton(
                  iconSize: 17.0,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (context) => DeleteDialog(
                        title: "Delete Machine",
                        content: "Are you sure?",
                        pos: "Yes",
                        neg: "Cancel",
                        id: vm.id!,
                        answer: (answer) =>
                            _deleteMachine(vm.id!, answer),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Serial:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(vm.id!, style: TextStyle(fontSize: 20), maxLines: 3, textAlign: TextAlign.center,),
                Text(
                  'Model:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(vm.name!),
                Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(vm.description!),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
