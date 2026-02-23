import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'SectionsList.dart';
  import 'SectionsProvider.dart';
  
  class SectionsPage extends StatelessWidget {
    const SectionsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => SectionsProvider(),
          child: MaterialApp(title: 'Sections ', home: SectionsList()));
    }
  }