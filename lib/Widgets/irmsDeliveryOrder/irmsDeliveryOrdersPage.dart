import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'irmsDeliveryOrdersList.dart';
import 'irmsDeliveryOrdersProvider.dart';

class irmsDeliveryOrdersPage extends StatelessWidget {
  const irmsDeliveryOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => irmsDeliveryOrdersProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: irmsDeliveryOrdersList()));
  }
}