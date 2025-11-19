import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CustomerSalesOrdersList.dart';
import 'CustomerSalesOrdersProvider.dart';

class CustomerSalesOrdersPage extends StatelessWidget {
  const CustomerSalesOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CustomerSalesOrdersProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: CustomerSalesOrdersList()));
  }
}