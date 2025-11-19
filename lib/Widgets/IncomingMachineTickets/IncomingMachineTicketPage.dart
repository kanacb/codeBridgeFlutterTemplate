import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'IncomingMachineTicketList.dart';
import 'IncomingMachineTicketProvider.dart';

class IncomingMachineTicketPage extends StatelessWidget {
  final String? successMessage;

  const IncomingMachineTicketPage({super.key, this.successMessage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => IncomingMachineTicketProvider(),
        child: MaterialApp(title: 'Incoming Machine App', home: IncomingMachineTicketList(successMessage: successMessage)));
  }
}