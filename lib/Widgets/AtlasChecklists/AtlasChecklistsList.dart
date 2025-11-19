import 'package:flutter/material.dart';
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
import 'AtlasChecklists.dart';
import 'AtlasChecklistsAdd.dart';
import 'AtlasChecklistsEdit.dart';
import 'AtlasChecklistsProvider.dart';

class AtlasChecklistsList extends StatefulWidget {
  const AtlasChecklistsList({super.key});

  @override
  State<AtlasChecklistsList> createState() => _AtlasChecklistsListState();
}

class _AtlasChecklistsListState extends State<AtlasChecklistsList> {
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
    schemaResponse = await AtlasChecklistsProvider().schema();
    setState(() {});
  }

  Future<void> _deleteChecklist(String id, bool confirm) async {
    if (confirm) {
      final provider = Provider.of<AtlasChecklistsProvider>(context, listen: false);
      Response response = await provider.deleteOne(id);

      if (response.isSuccess) {
        SnackBars().SuccessSnackBar(context, "Deleted checklist successfully");
        setState(() {
          provider.loadAtlasChecklistsFromHive(); // Refresh the data
        });
      } else {
        SnackBars().FailedSnackBar(context, "Failed to delete checklist");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final checklistsProvider = Provider.of<AtlasChecklistsProvider>(context);
    final checklists = checklistsProvider.data;

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerMenu(),
      body: checklistsProvider.isLoading
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

                // Show "No checklists" or the checklist list
                checklists.isEmpty
                    ? const Expanded(
                  child: Center(
                    child: Text('No checklists available'),
                  ),
                )
                    : Expanded(
                  child: _buildChecklistList(checklists),
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
      title: const Text('Atlas Checklists Management'),
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

  Widget _buildChecklistList(List<AtlasChecklists> checklists) {
    return ListView.builder(
      itemCount: checklists.length + 1, // Header + List Items
      itemBuilder: (context, index) {
        if (index == 0) return const SizedBox.shrink(); // Header already displayed
        final checklist = checklists[index - 1];
        return _buildChecklistCard(checklist, index - 1);
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
                _selected = List<bool>.filled(200, _allSelected, growable: true);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: _showFilterBy ? Colors.red : Colors.grey),
            onPressed: () => setState(() => _showFilterBy = !_showFilterBy),
          ),
          IconButton(
            icon: Icon(Icons.sort, color: _showSort ? Colors.red : Colors.grey),
            onPressed: () => setState(() => _showSort = !_showSort),
          ),
          IconButton(
            icon: Icon(Icons.list, color: _showFields ? Colors.red : Colors.grey),
            onPressed: () => setState(() => _showFields = !_showFields),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(utils.createRoute(
                  context, AtlasChecklistsAdd(resource: schemaResponse?.data)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard(AtlasChecklists checklist, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: _selected[index],
              onChanged: (value) => setState(() => _selected[index] = value!),
            ),
            title: Text(
              'Checklist Name: ${checklist.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${checklist.description}'),
                Text('Created By: ${checklist.createdBy}'),
                Text('Updated By: ${checklist.updatedBy}'),
                if (checklist.createdAt != null)
                  Text('Created At: ${checklist.createdAt}'),
                if (checklist.updatedAt != null)
                  Text('Updated At: ${checklist.updatedAt}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).push(utils.createRoute(
                        context,
                        AtlasChecklistsEdit(
                          resource: schemaResponse?.data,
                          checklist: checklist,
                        )));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (context) => DeleteDialog(
                        title: "Delete Checklist",
                        content: "Are you sure?",
                        pos: "Yes",
                        neg: "Cancel",
                        id: checklist.id!,
                        answer: (answer) => _deleteChecklist(checklist.id!, answer),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          _showMore[index]
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Checklist ID: ${checklist.id ?? "N/A"}'),
          )
              : const SizedBox(),
          TextButton(
            onPressed: () => setState(() => _showMore[index] = !_showMore[index]),
            child: Text(
              _showMore[index] ? 'Show less' : 'Show more',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
