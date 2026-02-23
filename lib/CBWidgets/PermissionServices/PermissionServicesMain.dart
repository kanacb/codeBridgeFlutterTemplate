import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'PermissionServicesList.dart';
  import 'PermissionServicesProvider.dart';
  
  class PermissionServicesPage extends StatelessWidget {
    const PermissionServicesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => PermissionServicesProvider(),
          child: MaterialApp(title: 'PermissionServices ', home: PermissionServicesList()));
    }
  }