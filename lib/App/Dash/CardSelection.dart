import 'package:flutter/material.dart';
import '../../Utils/Services/SharedPreferences.dart'; // Adjust if needed
import '../../App/Dash/DashMain.dart'; // This file should export Dashboard

class CardSelectionPage extends StatelessWidget {
  const CardSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Cards")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Card Selection Page"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Mark the dashboard setup as complete.
                await savePref("user_setup", "done");
                // Navigate back to Dashboard by removing all previous routes.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard(i: 0)),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text("Complete Setup"),
            ),
          ],
        ),
      ),
    );
  }
}
