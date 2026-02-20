import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'TemplatesList.dart';
  import 'TemplatesProvider.dart';
  
  class TemplatesPage extends StatelessWidget {
    const TemplatesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => TemplatesProvider(),
          child: MaterialApp(title: 'Templates ', home: TemplatesList()));
    }
  }