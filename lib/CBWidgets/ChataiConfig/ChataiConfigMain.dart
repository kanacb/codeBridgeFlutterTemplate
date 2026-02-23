import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'ChataiConfigList.dart';
  import 'ChataiConfigProvider.dart';
  
  class ChataiConfigPage extends StatelessWidget {
    const ChataiConfigPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => ChataiConfigProvider(),
          child: MaterialApp(title: 'ChataiConfig ', home: ChataiConfigList()));
    }
  }