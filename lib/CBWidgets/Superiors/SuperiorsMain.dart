import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'SuperiorsList.dart';
  import 'SuperiorsProvider.dart';
  
  class SuperiorsPage extends StatelessWidget {
    const SuperiorsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => SuperiorsProvider(),
          child: MaterialApp(title: 'Superiors ', home: SuperiorsList()));
    }
  }