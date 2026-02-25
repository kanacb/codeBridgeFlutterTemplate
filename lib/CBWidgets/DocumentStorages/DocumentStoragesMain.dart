import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'DocumentStoragesList.dart';
  import 'DocumentStoragesProvider.dart';
  
  class DocumentStoragesPage extends StatelessWidget {
    const DocumentStoragesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => DocumentStoragesProvider(),
          child: MaterialApp(title: 'DocumentStorages ', home: DocumentStoragesList()));
    }
  }