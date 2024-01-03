import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../users/userModel.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.user});
  final User user;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings for ${widget.user.name}"),
      ),
      body: const Center(
        child: Column(
          children: [Text("settings")],
        ),
      ),
    );
  }
}
