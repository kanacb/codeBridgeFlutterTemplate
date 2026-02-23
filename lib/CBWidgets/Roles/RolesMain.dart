import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'RolesList.dart';
  import 'RolesProvider.dart';
  
  class RolesPage extends StatelessWidget {
    const RolesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => RolesProvider(),
          child: MaterialApp(title: 'Roles ', home: RolesList()));
    }
  }