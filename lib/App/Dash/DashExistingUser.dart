// ExistingUserDash.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'ManageCardPage.dart';
import 'RecentItemsPage.dart';

class ExistingUserDash extends StatefulWidget {
  const ExistingUserDash({Key? key}) : super(key: key);

  @override
  State<ExistingUserDash> createState() => _ExistingUserDashState();
}

class _ExistingUserDashState extends State<ExistingUserDash> {
  // Dummy configuration for dashboard cards.
  final List<Map<String, dynamic>> cardConfigs = [
    {
      "title": "Recent Items",
      "description": "Your recently visited pages",
      "icon": Icons.history,
      "enabled": true,
    },
    {
      "title": "Favorites",
      "description": "Your favorite items",
      "icon": Icons.favorite,
      "enabled": true,
    },
    {
      "title": "Notifications",
      "description": "Your notifications",
      "icon": Icons.notifications,
      "enabled": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome Back!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cardConfigs.length,
              itemBuilder: (context, index) {
                final card = cardConfigs[index];
                if (card["enabled"] != true) return Container();

                if (card["title"] == "Recent Items") {
                  return FutureBuilder<List<String>>(
                    future: getRecentItems(),
                    builder: (context, snapshot) {
                      String description = card["description"];
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        description = "Last visited: ${snapshot.data![0]}";
                      }
                      return InkWell(
                        onTap: () {
                          // Navigate to a page that shows the full list
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const RecentItemsPage()),
                          ).then((_) {
                            setState(() {}); // Refresh the card when returning.
                          });
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(card["icon"],
                                    size: 48, color: Colors.red),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(card["title"],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Text(description,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // Other cards remain unchanged.
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(card["icon"],
                              size: 48, color: Colors.red),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(card["title"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(card["description"],
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ManageCardPage()));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Manage cards",
                  style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
