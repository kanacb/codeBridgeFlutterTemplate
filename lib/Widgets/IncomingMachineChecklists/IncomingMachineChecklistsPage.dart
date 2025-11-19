import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'IncomingMachineChecklistsList.dart';
import 'IncomingMachineChecklistsProvider.dart';

class IncomingMachineChecklistsPage extends StatelessWidget {
  const IncomingMachineChecklistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => IncomingMachineChecklistsProvider(),
        child: MaterialApp(title: 'Incoming Machine Checks App', home: IncomingMachineChecklistsList()));
  }
}