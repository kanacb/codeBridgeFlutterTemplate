import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'MailQuesList.dart';
  import 'MailQuesProvider.dart';
  
  class MailQuesPage extends StatelessWidget {
    const MailQuesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => MailQuesProvider(),
          child: MaterialApp(title: 'MailQues ', home: MailQuesList()));
    }
  }