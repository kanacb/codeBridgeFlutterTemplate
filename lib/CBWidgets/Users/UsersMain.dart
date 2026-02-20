import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UsersList.dart';
  import 'UsersProvider.dart';
  
  class UsersPage extends StatelessWidget {
    const UsersPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UsersProvider(),
          child: MaterialApp(title: 'Users ', home: UsersList()));
    }
  }