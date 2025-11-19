import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'irmsQuotationsList.dart';
import 'irmsQuotationsProvider.dart';

class irmsQuotationsPage extends StatelessWidget {
  const irmsQuotationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => irmsQuotationsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: irmsQuotationsList()));
  }
}