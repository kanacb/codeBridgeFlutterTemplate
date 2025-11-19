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
import 'PartsMaster.dart';
import 'PartsMasterAdd.dart';
import 'PartsMasterEdit.dart';
import 'PartsMasterProvider.dart';

class PartsMasterList extends StatefulWidget {
  const PartsMasterList({super.key});

  @override
  State<PartsMasterList> createState() => _PartsMasterListState();
}

class _PartsMasterListState extends State<PartsMasterList> {
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
    schemaResponse = await PartsMasterProvider().schema();
    setState(() {});
  }

  Future<void> _deletePart(String id, bool confirm) async {
    if (confirm) {
      final provider = Provider.of<PartsMasterProvider>(context, listen: false);
      Response response = await provider.deleteOne(id);

      if (response.isSuccess) {
        SnackBars().SuccessSnackBar(context, "Deleted part successfully");
        setState(() {
          provider.loadPartsMastersFromHive(); // Refresh the data
        });
      } else {
        SnackBars().FailedSnackBar(context, "Failed to delete part");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final partsProvider = Provider.of<PartsMasterProvider>(context);
    final parts = partsProvider.data;

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerMenu(),
      body: partsProvider.isLoading
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

                // Show "No parts" or the part list
                parts.isEmpty
                    ? const Expanded(
                  child: Center(
                    child: Text('No parts available'),
                  ),
                )
                    : Expanded(
                  child: _buildPartsList(parts),
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
      title: const Text('Parts Master Management'),
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

  Widget _buildPartsList(List<PartsMaster> parts) {
    return ListView.builder(
      itemCount: parts.length + 1, // Header + List Items
      itemBuilder: (context, index) {
        if (index == 0) return const SizedBox.shrink(); // Header already displayed
        final part = parts[index - 1];
        return _buildPartsCard(part, index - 1);
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
                  context, PartsMasterAdd(resource: schemaResponse?.data)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPartsCard(PartsMaster part, int index) {
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
              'Part Name: ${part.itemNo}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${part.description}'),
                Text('Quantity: ${part.quantity}'),
                Text('Cost Amount: ${part.costAmount}'),
                Text('Created By: ${part.createdBy}'),
                Text('Updated By: ${part.updatedBy}'),
                if (part.createdAt != null)
                  Text('Created At: ${part.createdAt}'),
                if (part.updatedAt != null)
                  Text('Updated At: ${part.updatedAt}'),
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
                        PartsMasterEdit(
                          resource: schemaResponse?.data,
                          parts: part,
                        )));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (context) => DeleteDialog(
                        title: "Delete Part",
                        content: "Are you sure?",
                        pos: "Yes",
                        neg: "Cancel",
                        id: part.itemNo!,
                        answer: (answer) => _deletePart(part.itemNo!, answer),
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
            // child: Text('Checklist ID: ${part.partListId ?? "N/A"}'),
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
