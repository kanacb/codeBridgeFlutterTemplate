import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'PermissionFieldsList.dart';
  import 'PermissionFieldsProvider.dart';
  
  class PermissionFieldsPage extends StatelessWidget {
    const PermissionFieldsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => PermissionFieldsProvider(),
          child: MaterialApp(title: 'PermissionFields ', home: PermissionFieldsList()));
    }
  }