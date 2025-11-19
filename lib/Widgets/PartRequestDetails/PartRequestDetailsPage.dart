import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PartRequestDetailsList.dart';
import 'PartRequestDetailsProvider.dart';

class PartRequestDetailsPage extends StatelessWidget {
  const PartRequestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PartRequestDetailsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: PartRequestDetailsList()));
  }
}