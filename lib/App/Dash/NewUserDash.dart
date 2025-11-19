import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../Utils/Services/SharedPreferences.dart';
import '../../Widgets/Users/User.dart';
import 'CardSelection.dart';
import 'ManageCardPage.dart';

class NewUserDash extends StatefulWidget {
  const NewUserDash({super.key});

  @override
  State<NewUserDash> createState() => _NewUserDashState();
}

class _NewUserDashState extends State<NewUserDash> {
  var size, height, width;
  User? _user;
  String intro =
      "Let's get started with customising your dashboard by adding cards to track the data as stats that matter most, all accessible at a glance";
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    var str = await getPref("user");
    if (str != null) {
      setState(() {
        _user = User.fromJson(jsonDecode(str));
        _enabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Optional gradient background container.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Dashboard image.
          Image.asset(
            "assets/images/new_user_dash_img.png",
            width: width / 2,
            alignment: Alignment.topCenter,
          ),
          const SizedBox(height: 20),
          // Welcome message (using Skeletonizer until user data is loaded).
          Skeletonizer(
            enabled: _enabled,
            child: Text(
              "Welcome, ${_user?.name ?? 'User'}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Introduction text.
          Text(
            intro,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          // "Guide me" button.
          ElevatedButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const CardSelectionPage(),
              //   ),
              // );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.red),
              padding:
              const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 12),
          // "Manage cards" button.
          // ElevatedButton(
          //   onPressed: () {
          //     debugPrint("Manage cards button pressed");
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const ManageCardPage(),
          //       ),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.red,
          //     padding:
          //     const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          //   child: const Text(
          //     'Manage cards',
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}
