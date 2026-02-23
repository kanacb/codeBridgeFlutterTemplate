import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'DepartmentHODList.dart';
  import 'DepartmentHODProvider.dart';
  
  class DepartmentHODPage extends StatelessWidget {
    const DepartmentHODPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => DepartmentHODProvider(),
          child: MaterialApp(title: 'DepartmentHOD ', home: DepartmentHODList()));
    }
  }