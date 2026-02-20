import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'CompanyPhonesList.dart';
  import 'CompanyPhonesProvider.dart';
  
  class CompanyPhonesPage extends StatelessWidget {
    const CompanyPhonesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => CompanyPhonesProvider(),
          child: MaterialApp(title: 'CompanyPhones ', home: CompanyPhonesList()));
    }
  }