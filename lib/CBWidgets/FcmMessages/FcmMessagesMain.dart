import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'FcmMessagesList.dart';
  import 'FcmMessagesProvider.dart';
  
  class FcmMessagesPage extends StatelessWidget {
    const FcmMessagesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => FcmMessagesProvider(),
          child: MaterialApp(title: 'FcmMessages ', home: FcmMessagesList()));
    }
  }