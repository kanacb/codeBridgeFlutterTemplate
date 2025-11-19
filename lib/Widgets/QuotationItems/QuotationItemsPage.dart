import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'QuotationItemsList.dart';
import 'QuotationItemsProvider.dart';

class QuotationItemsPage extends StatelessWidget {
  const QuotationItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => QuotationItemsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: QuotationItemsList()));
  }
}