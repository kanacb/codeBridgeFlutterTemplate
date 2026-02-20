import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'EmployeesList.dart';
  import 'EmployeesProvider.dart';
  
  class EmployeesPage extends StatelessWidget {
    const EmployeesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => EmployeesProvider(),
          child: MaterialApp(title: 'Employees ', home: EmployeesList()));
    }
  }