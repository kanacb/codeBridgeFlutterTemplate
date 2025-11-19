import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DisposalDetailsList.dart';
import 'DisposalDetailsProvider.dart';

class DisposalDetailsPage extends StatelessWidget {
  const DisposalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DisposalDetailsProvider(),
        child: MaterialApp(title: 'Customer Sales Orders Page', home: DisposalDetailsList()));
  }
}