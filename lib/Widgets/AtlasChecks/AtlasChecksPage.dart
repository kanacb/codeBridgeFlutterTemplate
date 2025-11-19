import '../../Widgets/AtlasChecks/AtlasChecksList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AtlasChecksProvider.dart';

class AtlasChecksPage extends StatelessWidget {
  const AtlasChecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AtlasChecksProvider(),
        child: MaterialApp(title: 'Atlas App', home: AtlasChecksList()));
  }
}