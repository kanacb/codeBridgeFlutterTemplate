import '../../Widgets/PartsMaster/PartsMasterList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PartsMasterProvider.dart';

class PartsMasterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PartsMasterProvider(),
        child: MaterialApp(title: 'Parts App', home: PartsMasterList()));
  }
}