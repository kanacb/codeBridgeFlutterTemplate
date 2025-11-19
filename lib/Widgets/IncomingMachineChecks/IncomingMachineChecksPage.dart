import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'IncomingMachineChecksList.dart';
import 'IncomingMachineChecksProvider.dart';

class IncomingMachineChecksPage extends StatelessWidget {
  const IncomingMachineChecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => IncomingMachineChecksProvider(),
        child: MaterialApp(title: 'Incoming Machine Checks App', home: IncomingMachineChecksList()));
  }
}