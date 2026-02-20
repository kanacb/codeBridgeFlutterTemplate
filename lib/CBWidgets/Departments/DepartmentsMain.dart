import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'DepartmentsList.dart';
  import 'DepartmentsProvider.dart';
  
  class DepartmentsPage extends StatelessWidget {
    const DepartmentsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => DepartmentsProvider(),
          child: MaterialApp(title: 'Departments ', home: DepartmentsList()));
    }
  }