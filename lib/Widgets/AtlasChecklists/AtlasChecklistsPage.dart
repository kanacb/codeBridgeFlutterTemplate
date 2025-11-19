import '../../Widgets/ExternalChecklists/ExternalChecklistsList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AtlasChecklistsList.dart';
import 'AtlasChecklistsProvider.dart';

class AtlasChecklistsPage extends StatelessWidget {
  const AtlasChecklistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AtlasChecklistsProvider(),
        child: MaterialApp(title: 'Atlas App', home: AtlasChecklistsList()));
  }
}