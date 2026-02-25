import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'HelpSidebarContentsList.dart';
  import 'HelpSidebarContentsProvider.dart';
  
  class HelpSidebarContentsPage extends StatelessWidget {
    const HelpSidebarContentsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => HelpSidebarContentsProvider(),
          child: MaterialApp(title: 'HelpSidebarContents ', home: HelpSidebarContentsList()));
    }
  }