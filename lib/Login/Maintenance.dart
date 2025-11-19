import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image(image: AssetImage("assets/images/maintenance.png")),
          Text("We will be back soon"),
          Text("Our site is currently undergoing maintenance to improve your experience. Please check back later. Thank you for your patience!")
        ],
      ),
    );
  }
}
