import 'package:flutter/material.dart';
import '../../components/users/users.dart';

class Preferences extends StatefulWidget {
  const Preferences({super.key, required this.user});
  final Users user;
  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferences for ${widget.user.name}"),
      ),
      body: const Center(
        child: Column(
          children: [Text("prefs")],
        ),
      ),
    );
  }
}
