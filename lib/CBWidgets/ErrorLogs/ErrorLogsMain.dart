import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'ErrorLogsList.dart';
  import 'ErrorLogsProvider.dart';
  
  class ErrorLogsPage extends StatelessWidget {
    const ErrorLogsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => ErrorLogsProvider(),
          child: MaterialApp(title: 'ErrorLogs ', home: ErrorLogsList()));
    }
  }