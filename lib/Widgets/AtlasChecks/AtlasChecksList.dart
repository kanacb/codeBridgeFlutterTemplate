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
import 'AtlasChecks.dart';
import 'AtlasChecksAdd.dart';
import 'AtlasChecksEdit.dart';
import 'AtlasChecksProvider.dart';

class AtlasChecksList extends StatefulWidget {
  const AtlasChecksList({super.key});

  @override
  State<AtlasChecksList> createState() => _AtlasChecksListState();
}

class _AtlasChecksListState extends State<AtlasChecksList> {
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
    schemaResponse = await AtlasChecksProvider().schema();
    setState(() {});
  }

  Future<void> _deleteCheck(String id, bool confirm) async {
    if (confirm) {
      final provider = Provider.of<AtlasChecksProvider>(context, listen: false);
      Response response = await provider.deleteOne(id);

      if (response.isSuccess) {
        SnackBars().SuccessSnackBar(context, "Deleted check successfully");
        setState(() {
          provider.loadAtlasChecksFromHive(); // Refresh the data
        });
      } else {
        SnackBars().FailedSnackBar(context, "Failed to delete check");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final checksProvider = Provider.of<AtlasChecksProvider>(context);
    final checks = checksProvider.data;

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerMenu(),
      body: checksProvider.isLoading
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

                // Show "No checks" or the check list
                checks.isEmpty
                    ? const Expanded(
                  child: Center(
                    child: Text('No checks available'),
                  ),
                )
                    : Expanded(
                  child: _buildCheckList(checks),
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
      title: const Text('Atlas Checks Management'),
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

  Widget _buildCheckList(List<AtlasChecks> checks) {
    return ListView.builder(
      itemCount: checks.length + 1, // Header + List Items
      itemBuilder: (context, index) {
        if (index == 0) return const SizedBox.shrink(); // Header already displayed
        final check = checks[index - 1];
        return _buildCheckCard(check, index - 1);
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
                  context, AtlasChecksAdd(resource: schemaResponse?.data)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckCard(AtlasChecks check, int index) {
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
              'Check Name: ${check.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${check.description}'),
                Text('Created By: ${check.createdBy}'),
                Text('Updated By: ${check.updatedBy}'),
                if (check.createdAt != null)
                  Text('Created At: ${check.createdAt}'),
                if (check.updatedAt != null)
                  Text('Updated At: ${check.updatedAt}'),
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
                        AtlasChecksEdit(
                          resource: schemaResponse?.data,
                          check: check,
                        )));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (context) => DeleteDialog(
                        title: "Delete Check",
                        content: "Are you sure?",
                        pos: "Yes",
                        neg: "Cancel",
                        id: check.id!,
                        answer: (answer) => _deleteCheck(check.id!, answer),
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
            child: Text('Checklist ID: ${check.checkListId ?? "N/A"}'),
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
