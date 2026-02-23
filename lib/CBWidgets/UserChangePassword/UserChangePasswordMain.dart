import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UserChangePasswordList.dart';
  import 'UserChangePasswordProvider.dart';
  
  class UserChangePasswordPage extends StatelessWidget {
    const UserChangePasswordPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UserChangePasswordProvider(),
          child: MaterialApp(title: 'UserChangePassword ', home: UserChangePasswordList()));
    }
  }