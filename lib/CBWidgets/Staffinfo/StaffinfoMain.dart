import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'StaffinfoList.dart';
  import 'StaffinfoProvider.dart';
  
  class StaffinfoPage extends StatelessWidget {
    const StaffinfoPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => StaffinfoProvider(),
          child: MaterialApp(title: 'Staffinfo ', home: StaffinfoList()));
    }
  }