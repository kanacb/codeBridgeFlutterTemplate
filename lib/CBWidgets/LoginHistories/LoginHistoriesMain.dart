import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'LoginHistoriesList.dart';
  import 'LoginHistoriesProvider.dart';
  
  class LoginHistoriesPage extends StatelessWidget {
    const LoginHistoriesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => LoginHistoriesProvider(),
          child: MaterialApp(title: 'LoginHistories ', home: LoginHistoriesList()));
    }
  }