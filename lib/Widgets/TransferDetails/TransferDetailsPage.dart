import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TransferDetailsList.dart';
import 'TransferDetailsProvider.dart';

class TransferDetailsPage extends StatelessWidget {
  const TransferDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TransferDetailsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: TransferDetailsList()));
  }
}