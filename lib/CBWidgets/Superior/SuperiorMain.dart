import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'SuperiorList.dart';
  import 'SuperiorProvider.dart';
  
  class SuperiorPage extends StatelessWidget {
    const SuperiorPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => SuperiorProvider(),
          child: MaterialApp(title: 'Superior ', home: SuperiorList()));
    }
  }