import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'WarehouseMasterList.dart';
import 'WarehouseMasterProvider.dart';

class WarehouseMasterPage extends StatelessWidget {
  const WarehouseMasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => WarehouseMasterProvider(),
        child: MaterialApp(title: 'Warehouse Page', home: WarehouseMasterList()));
  }
}