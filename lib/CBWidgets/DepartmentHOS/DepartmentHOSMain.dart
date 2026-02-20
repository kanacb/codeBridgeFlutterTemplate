import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'DepartmentHOSList.dart';
  import 'DepartmentHOSProvider.dart';
  
  class DepartmentHOSPage extends StatelessWidget {
    const DepartmentHOSPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => DepartmentHOSProvider(),
          child: MaterialApp(title: 'DepartmentHOS ', home: DepartmentHOSList()));
    }
  }