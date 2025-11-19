import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/Dialogs/BuildSvgIcon.dart';
import '../../Utils/Dialogs/DrawerMenu.dart';

class DashboardHelp extends StatelessWidget {
  const DashboardHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: BuildSvgIcon(
              assetName: 'assets/svg/logo.svg', index: 1, currentIndex: 1),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                // Handle action
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle action
              },
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.red,
        ),
        drawer: DrawerMenu(),
        body: Center(
          child: Text("Todo Help Page"),
        ));
  }
}
