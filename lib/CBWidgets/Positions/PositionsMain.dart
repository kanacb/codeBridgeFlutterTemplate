import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'PositionsList.dart';
  import 'PositionsProvider.dart';
  
  class PositionsPage extends StatelessWidget {
    const PositionsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => PositionsProvider(),
          child: MaterialApp(title: 'Positions ', home: PositionsList()));
    }
  }