import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'ChataiPromptsList.dart';
  import 'ChataiPromptsProvider.dart';
  
  class ChataiPromptsPage extends StatelessWidget {
    const ChataiPromptsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => ChataiPromptsProvider(),
          child: MaterialApp(title: 'ChataiPrompts ', home: ChataiPromptsList()));
    }
  }