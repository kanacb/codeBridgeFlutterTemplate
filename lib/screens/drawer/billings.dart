import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vx_index/main.dart';

import '../../users/userModel.dart';

class Billings extends StatefulWidget {
  const Billings({super.key});

  @override
  State<Billings> createState() => _BillingsState();
}

class _BillingsState extends State<Billings> {
  late User user;

  getUser() async {
    user = await flutterFeathersJS.rest.reAuthenticate();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Billings for ${user.name}"),
      ),
      body: const Center(
        child: Column(
          children: [Text("bills")],
        ),
      ),
    );
  }
}
