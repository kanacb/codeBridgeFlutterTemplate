import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UserPhonesList.dart';
  import 'UserPhonesProvider.dart';
  
  class UserPhonesPage extends StatelessWidget {
    const UserPhonesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UserPhonesProvider(),
          child: MaterialApp(title: 'UserPhones ', home: UserPhonesList()));
    }
  }