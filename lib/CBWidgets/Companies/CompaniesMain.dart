import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'CompaniesList.dart';
  import 'CompaniesProvider.dart';
  
  class CompaniesPage extends StatelessWidget {
    const CompaniesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => CompaniesProvider(),
          child: MaterialApp(title: 'Companies ', home: CompaniesList()));
    }
  }