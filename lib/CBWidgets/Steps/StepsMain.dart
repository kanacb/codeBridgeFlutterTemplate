import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'StepsList.dart';
  import 'StepsProvider.dart';
  
  class StepsPage extends StatelessWidget {
    const StepsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => StepsProvider(),
          child: MaterialApp(title: 'Steps ', home: StepsList()));
    }
  }