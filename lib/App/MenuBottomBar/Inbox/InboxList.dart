import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Utils/Services/SharedPreferences.dart';
import 'Inbox.dart';
import 'InboxDetail.dart';
import 'InboxProvider.dart'; // For getPref() usage

class InboxList extends StatefulWidget {
  const InboxList({super.key});

  @override
  State<InboxList> createState() => _InboxListState();
}

class _InboxListState extends State<InboxList> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    // Retrieve current user ID from shared preferences.
    _loadCurrentUserId();
    Future.microtask(() {
      Provider.of<InboxProvider>(context, listen: false).fetchAllAndSave();
    });
  }

  Future<void> _loadCurrentUserId() async {
    // Retrieve the stored user JSON (set during login)
    final String? userJson = await getPref("user");
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      // Adjust the key as needed. Some APIs use "id", others "_id".
      setState(() {
        currentUserId = userMap["_id"] ?? userMap["id"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // While loading the current user, show a loader.
    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final inboxProvider = Provider.of<InboxProvider>(context);
    debugPrint("InboxList rebuild: ${inboxProvider.inboxes.length} items loaded.");

    // Inbox: messages where the current user is the recipient.
    final List<Inbox> inboxMessages = inboxProvider.inboxes.where((msg) {
      final recipientId = msg.toUser is String ? msg.toUser : (msg.toUser as dynamic).sId;
      return recipientId == currentUserId;
    }).toList();

    // Sent: messages where the current user is the sender.
    final List<Inbox> sentMessages = inboxProvider.inboxes.where((msg) {
      final senderId = msg.from is String ? msg.from : (msg.from as dynamic).sId;
      return senderId == currentUserId;
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inbox'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Inbox"),
              Tab(text: "Sent"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMessageList(inboxMessages, "No messages in Inbox"),
            _buildMessageList(sentMessages, "No sent messages"),
          ],
        ),
      ),
    );
  }

  /// Builds a list of messages or displays an empty placeholder.
  Widget _buildMessageList(List<Inbox> messages, String emptyMessage) {
    return messages.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) => _buildMessageItem(context, messages[index]),
    );
  }

  Widget _buildMessageItem(BuildContext context, Inbox message) {
    final bool isUnread = !message.read;
    final String? senderName = message.from is String
        ? message.from
        : (message.from as dynamic).name;
    final String subject = message.subject;
    final String snippet = message.content.replaceAll(RegExp(r'<[^>]*>'), '');
    final Color leftIndicatorColor = isUnread ? Colors.red : Colors.transparent;
    final Color tagColor = _getTagColor(message.service);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InboxDetailPage(id: message.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Container(width: 4, height: 80, color: leftIndicatorColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            senderName ?? '',
                            style: TextStyle(
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(message.sent),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subject,
                      style: TextStyle(
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      snippet,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: tagColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message.service,
                            style: TextStyle(color: tagColor, fontSize: 12),
                          ),
                        ),
                        const Spacer(),
                        if (message.flagged)
                          const Icon(Icons.push_pin, color: Colors.red, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final int day = date.day;
    final String month = _getMonth(date.month);
    final int year = date.year;
    return "$day $month $year";
  }

  Color _getTagColor(String service) {
    switch (service.toLowerCase()) {
      case "staff info":
        return Colors.blue;
      case "users":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getMonth(int month) {
    const List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }
}
