import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'DocumentStorageList.dart';
  import 'DocumentStorageProvider.dart';
  
  class DocumentStoragePage extends StatelessWidget {
    const DocumentStoragePage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => DocumentStorageProvider(),
          child: MaterialApp(title: 'DocumentStorage ', home: DocumentStorageList()));
    }
  }