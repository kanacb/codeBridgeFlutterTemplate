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
import 'ChataiPrompt.dart';
import 'ChataiPromptsAdd.dart';
import 'ChataiPromptsEdit.dart';
import 'ChataiPromptsProvider.dart';


class ChataiPromptsList extends StatefulWidget {
  const ChataiPromptsList({super.key});

  @override
  State<ChataiPromptsList> createState() => _ChataiPromptsListState();
}

class _ChataiPromptsListState extends State<ChataiPromptsList> {
  final Logger logger = globals.logger;
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
    schemaResponse = await ChataiPromptsProvider().schema();
    setState(() {});
  }

  Future<void> _delete(String id, bool confirm) async {
    if (confirm) {
      final provider = Provider.of<ChataiPromptsProvider>(context, listen: false);
      Response response = await provider.deleteOne(id);

      if (response.isSuccess) {
        SnackBars().SuccessSnackBar(context, "Deleted ticket successfully");
        setState(() {
          provider.loadChataiPromptsFromHive();
        });
      } else {
        SnackBars().FailedSnackBar(context, "Failed to delete ticket");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChataiPromptsProvider>(context);
    final data = provider.data;

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerMenu(),
      body: provider.isLoading
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
                _buildHeader(),
                data.isEmpty
                    ? const Expanded(
                  child: Center(
                    child: Text('No data available'),
                  ),
                )
                    : Expanded(child: _buildList(data)),
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
      title: const Text('ChataiPrompts Details'),
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

  Widget _buildHeader() {
    return Card(
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
              Navigator.of(context).push(Utils().createRoute(
                  context, ChataiPromptsAdd(resource: schemaResponse?.data)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<ChataiPrompt> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return _buildCard(item, index);
      },
    );
  }

  Widget _buildCard(ChataiPrompt item, int index) {
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
              'Title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Session: ${item.session}'),
Text('Chat AI Enabler: ${item.chatAiEnabler?.name}'),
Text('Chat Ai Config: ${item.chatAiConfig?.name}'),
Text('Prompt: ${item.prompt}'),
Text('Ref Docs: ${item.refDocs}'),
Text('Response Text: ${item.responseText}'),
Text('System Id: ${item.systemId}'),
Text('Type: ${item.type}'),
Text('Role: ${item.role}'),
Text('Model: ${item.model}'),
Text('Params: ${item.params}'),
Text('Stop Reason: ${item.stopReason}'),
Text('Stop Sequence: ${item.stopSequence}'),
Text('Input Tokens: ${item.inputTokens}'),
Text('Output Tokens: ${item.outputTokens}'),
Text('Cost: ${item.cost}'),
Text('Status: ${item.status}'),
Text('Error: ${item.error}'),
Text('User Remarks: ${item.userRemarks}'),
Text('Thumbs Down: ${item.thumbsDown}'),
Text('Thumbs Up: ${item.thumbsUp}'),
Text('Copies: ${item.copies}'),
Text('Emailed: ${item.emailed}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).push(Utils().createRoute(
                        context,
                        ChataiPromptsEdit(
                          schema: schemaResponse?.data,
                          data: item,
                          
                        )));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (context) => DeleteDialog(
                        title: "Delete",
                        content: "Are you sure?",
                        pos: "Yes",
                        neg: "Cancel",
                        id: item.id.toString(),
                        answer: (answer) => _delete(item.id.toString(), answer),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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