import 'package:flutter/material.dart';
import '../../Utils/Services/SharedPreferences.dart';
import '../../App/Dash/DashMain.dart';

/// Model for a dashboard card configuration.
class DashboardCardConfig {
  String title;
  bool enabled;
  DashboardCardConfig({required this.title, this.enabled = true});
}

class ManageCardPage extends StatefulWidget {
  const ManageCardPage({super.key});

  @override
  State<ManageCardPage> createState() => _ManageCardPageState();
}

class _ManageCardPageState extends State<ManageCardPage> {
  // Initial card configuration. In a real app, load/save these settings persistently.
  List<DashboardCardConfig> cards = [
    DashboardCardConfig(title: "Recent Items", enabled: true),
    DashboardCardConfig(title: "Favorites", enabled: true),
    DashboardCardConfig(title: "Notifications", enabled: true),
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final DashboardCardConfig card = cards.removeAt(oldIndex);
      cards.insert(newIndex, card);
    });
  }

  void _saveChanges() {
    // Save changes persistently (e.g., using SharedPreferences).
    debugPrint("Saved card configuration:");
    for (final card in cards) {
      debugPrint("${card.title}: ${card.enabled}");
    }
    Navigator.pop(context, cards);
  }

  // Remove only the 'user_setup' preference so that the app switches back to NewUserDash.
  Future<void> _resetPreferences() async {
    // Instead of clearPref() (which clears everything), remove only the 'user_setup' key.
    await removePrefKey("user_setup");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Dashboard preferences reset.")),
    );
    // Remove all routes and push a new Dashboard.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard(i: 0)),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Cards"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              onReorder: _onReorder,
              padding: const EdgeInsets.all(16.0),
              children: [
                for (final card in cards)
                  ListTile(
                    key: ValueKey(card.title),
                    title: Text(card.title),
                    trailing: Switch(
                      value: card.enabled,
                      onChanged: (value) {
                        setState(() {
                          card.enabled = value;
                        });
                      },
                    ),
                  )
              ],
            ),
          ),
          // Reset Preferences button styled like the "Manage cards" button.
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: _resetPreferences,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Reset Preferences',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
