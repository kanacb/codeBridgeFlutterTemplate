import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'InboxList.dart';
  import 'InboxProvider.dart';
  
  class InboxPage extends StatelessWidget {
    const InboxPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => InboxProvider(),
          child: MaterialApp(title: 'Inbox ', home: InboxList()));
    }
  }