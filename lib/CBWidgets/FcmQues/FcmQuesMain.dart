import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'FcmQuesList.dart';
  import 'FcmQuesProvider.dart';
  
  class FcmQuesPage extends StatelessWidget {
    const FcmQuesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => FcmQuesProvider(),
          child: MaterialApp(title: 'FcmQues ', home: FcmQuesList()));
    }
  }