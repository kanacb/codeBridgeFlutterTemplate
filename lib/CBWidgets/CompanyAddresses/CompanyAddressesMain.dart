import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'CompanyAddressesList.dart';
  import 'CompanyAddressesProvider.dart';
  
  class CompanyAddressesPage extends StatelessWidget {
    const CompanyAddressesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => CompanyAddressesProvider(),
          child: MaterialApp(title: 'CompanyAddresses ', home: CompanyAddressesList()));
    }
  }