import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'ChataiEnablerList.dart';
  import 'ChataiEnablerProvider.dart';
  
  class ChataiEnablerPage extends StatelessWidget {
    const ChataiEnablerPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => ChataiEnablerProvider(),
          child: MaterialApp(title: 'ChataiEnabler ', home: ChataiEnablerList()));
    }
  }