import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UserAddressesList.dart';
  import 'UserAddressesProvider.dart';
  
  class UserAddressesPage extends StatelessWidget {
    const UserAddressesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UserAddressesProvider(),
          child: MaterialApp(title: 'UserAddresses ', home: UserAddressesList()));
    }
  }