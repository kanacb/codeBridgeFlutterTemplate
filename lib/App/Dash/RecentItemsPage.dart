// RecentItemsPage.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../Utils/Services/SharedPreferences.dart';

const String recentItemsKey = 'recent_items';

// Retrieves the recent items.
Future<List<String>> getRecentItems() async {
  final jsonString = await getPref(recentItemsKey);
  if (jsonString == null) return [];
  try {
    final List<dynamic> jsonList = json.decode(jsonString);
    return List<String>.from(jsonList);
  } catch (e) {
    return [];
  }
}

class RecentItemsPage extends StatefulWidget {
  const RecentItemsPage({Key? key}) : super(key: key);  

  @override
  State<RecentItemsPage> createState() => _RecentItemsPageState();
}

class _RecentItemsPageState extends State<RecentItemsPage> {
  late Future<List<String>> recentItemsFuture;

  @override
  void initState() {
    super.initState();
    recentItemsFuture = getRecentItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Items")),
      body: FutureBuilder<List<String>>(
        future: recentItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text("No recent items found."));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),
                onTap: () {
                  // Optional: perform an action when a recent item is tapped.
                },
              );
            },
          );
        },
      ),
    );
  }
}
