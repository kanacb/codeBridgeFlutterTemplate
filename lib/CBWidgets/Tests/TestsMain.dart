import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'TestsList.dart';
  import 'TestsProvider.dart';
  
  class TestsPage extends StatelessWidget {
    const TestsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => TestsProvider(),
          child: MaterialApp(title: 'Tests ', home: TestsList()));
    }
  }