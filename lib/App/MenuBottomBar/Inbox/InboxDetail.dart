import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' as html_parser;
import 'Inbox.dart';
import 'InboxProvider.dart';

class InboxDetailPage extends StatelessWidget {
  final String id;

  const InboxDetailPage({Key? key, required this.id}) : super(key: key);

  /// Parses the HTML string and returns the extracted plain text.
  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final parsedText = document.body?.text.trim() ?? "";
    return parsedText;
  }

  @override
  Widget build(BuildContext context) {
    // Access your InboxProvider to retrieve the list of messages.
    final inboxProvider = Provider.of<InboxProvider>(context);

    // Find the message by its ID.
    Inbox? message;
    try {
      message = inboxProvider.inboxes.firstWhere((msg) => msg.id == id);
    } catch (e) {
      message = null;
    }

    if (message == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Message Detail")),
        body: const Center(child: Text("Message not found.")),
      );
    }

    // Extract fields from the message.
    final senderName = message.from is String
        ? message.from
        : (message.from as dynamic).name;
    final recipientName = message.toUser is String
        ? message.toUser
        : (message.toUser as dynamic).name;
    final subject = message.subject;
    final rawContent = message.content.trim(); // May contain HTML.
    final service = message.service;
    final sentDate = message.sent; // DateTime field.

    // Check if rawContent is literally "undefined". If so, use an empty string.
    final plainTextContent = rawContent.toLowerCase() == "undefined"
        ? ""
        : parseHtmlString(rawContent);

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.isNotEmpty ? subject : "Message Detail"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "From: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          senderName ?? "",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // To:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "To: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          recipientName ?? "",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Sent Date & Service Tag:
                  Row(
                    children: [
                      const Text(
                        "Sent: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _formatDateTime(sentDate),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      // Service Tag:
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getTagColor(service).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          service,
                          style: TextStyle(
                            color: _getTagColor(service),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Subject ---
            Text(
              subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            // --- Message Body ---
            Text(
              plainTextContent,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            // --- Additional sections can be added below if needed ---
          ],
        ),
      ),
    );
  }

  /// Formats the sent DateTime into a string like "23 Sep 2024, 4:05 PM".
  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day;
    final month = _getMonthName(dateTime.month);
    final year = dateTime.year;
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? "PM" : "AM";
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return "$day $month $year, $displayHour:$minute $ampm";
  }

  /// Returns an abbreviated month name.
  String _getMonthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  /// Returns a color for the service tag.
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
}
