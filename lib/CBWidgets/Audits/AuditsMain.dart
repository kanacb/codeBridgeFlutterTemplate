import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'AuditsList.dart';
  import 'AuditsProvider.dart';
  
  class AuditsPage extends StatelessWidget {
    const AuditsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => AuditsProvider(),
          child: MaterialApp(title: 'Audits ', home: AuditsList()));
    }
  }