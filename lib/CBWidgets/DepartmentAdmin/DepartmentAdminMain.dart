import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'DepartmentAdminList.dart';
  import 'DepartmentAdminProvider.dart';
  
  class DepartmentAdminPage extends StatelessWidget {
    const DepartmentAdminPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => DepartmentAdminProvider(),
          child: MaterialApp(title: 'DepartmentAdmin ', home: DepartmentAdminList()));
    }
  }