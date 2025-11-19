import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'StockInDetailsList.dart';
import 'StockInDetailsProvider.dart';

class StockInDetailsPage extends StatelessWidget {
  const StockInDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => StockInDetailsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: StockInDetailsList()));
  }
}