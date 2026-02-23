import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'HelpBarContentsList.dart';
  import 'HelpBarContentsProvider.dart';
  
  class HelpBarContentsPage extends StatelessWidget {
    const HelpBarContentsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => HelpBarContentsProvider(),
          child: MaterialApp(title: 'HelpBarContents ', home: HelpBarContentsList()));
    }
  }