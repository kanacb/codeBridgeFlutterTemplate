import 'package:flutter/material.dart';
import 'InboxList.dart'; // Adjust this import to your file structure

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Inbox and Sent
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inbox'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Inbox'),
              Tab(text: 'Sent'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            InboxList(), // Real inbox list (uses provider to fetch & display data)
            Center(child: Text("Sent items will appear here.")),
          ],
        ),
      ),
    );
  }
}
