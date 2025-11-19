import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DeliveryOrderItemsList.dart';
import 'DeliveryOrderItemsProvider.dart';

class DeliveryOrderItemsPage extends StatelessWidget {
  const DeliveryOrderItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DeliveryOrderItemsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: DeliveryOrderItemsList()));
  }
}