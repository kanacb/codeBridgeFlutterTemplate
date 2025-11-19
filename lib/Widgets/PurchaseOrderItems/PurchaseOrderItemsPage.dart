import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PurchaseOrderItemsList.dart';
import 'PurchaseOrderItemsProvider.dart';

class PurchaseOrderItemsPage extends StatelessWidget {
  const PurchaseOrderItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PurchaseOrderItemsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: PurchaseOrderItemsList()));
  }
}