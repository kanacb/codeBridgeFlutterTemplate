import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MemTicketList.dart';
import 'MemTicketProvider.dart';

class MemTicketPage extends StatelessWidget {
  final String? successMessage;

  const MemTicketPage({super.key, this.successMessage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MemTicketProvider(),
        child: MaterialApp(title: 'MEM App', home: MemTicketList(successMessage: successMessage)));
  }
}