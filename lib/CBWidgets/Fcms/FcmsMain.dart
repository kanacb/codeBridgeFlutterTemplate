import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'FcmsList.dart';
  import 'FcmsProvider.dart';
  
  class FcmsPage extends StatelessWidget {
    const FcmsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => FcmsProvider(),
          child: MaterialApp(title: 'Fcms ', home: FcmsList()));
    }
  }