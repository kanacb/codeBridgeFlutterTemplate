import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ExternalChecksProvider.dart';

class ExternalChecksPage extends StatelessWidget {
  const ExternalChecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ExternalChecksProvider(),
        child: MaterialApp(title: 'External App', home: ExternalChecksList()));
  }
}