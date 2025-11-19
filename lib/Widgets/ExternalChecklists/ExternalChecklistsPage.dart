import '../../Widgets/ExternalChecklists/ExternalChecklistsList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ExternalChecklistsProvider.dart';

class ExternalChecklistsPage extends StatelessWidget {
  const ExternalChecklistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ExternalChecklistsProvider(),
        child: MaterialApp(title: 'External App', home: ExternalChecklistsList()));
  }
}