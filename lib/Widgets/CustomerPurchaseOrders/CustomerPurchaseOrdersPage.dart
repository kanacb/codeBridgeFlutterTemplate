import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CustomerPurchaseOrdersList.dart';
import 'CustomerPurchaseOrdersProvider.dart';

class CustomerPurchaseOrdersPage extends StatelessWidget {
  const CustomerPurchaseOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CustomerPurchaseOrdersProvider(),
        child: MaterialApp(title: 'Customer Purchase Orders Page', home: CustomerPurchaseOrdersList()));
  }
}