import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SalesOrderItemsList.dart';
import 'SalesOrderItemsProvider.dart';

class SalesOrderItemsPage extends StatelessWidget {
  const SalesOrderItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SalesOrderItemsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: SalesOrderItemsList()));
  }
}