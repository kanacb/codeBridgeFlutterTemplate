import '../../Widgets/MachineMaster/MachineMasterList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'VendingMachineProvider.dart';

class MachineMasterPage extends StatelessWidget {
  const MachineMasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => VendingMachineProvider(),
        child: MaterialApp(title: 'External App', home: MachineMasterList()));
  }
}