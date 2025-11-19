import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'StockOutDetailsList.dart';
import 'StockOutDetailsProvider.dart';

class StockOutDetailsPage extends StatelessWidget {
  const StockOutDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => StockOutDetailsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: StockOutDetailsList()));
  }
}