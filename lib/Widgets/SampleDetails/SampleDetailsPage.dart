import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SampleDetailsList.dart';
import 'SampleDetailsProvider.dart';

class SampleDetailsPage extends StatelessWidget {
  const SampleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SampleDetailsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: SampleDetailsList()));
  }
}