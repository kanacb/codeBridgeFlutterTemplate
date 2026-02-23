import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UploaderList.dart';
  import 'UploaderProvider.dart';
  
  class UploaderPage extends StatelessWidget {
    const UploaderPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UploaderProvider(),
          child: MaterialApp(title: 'Uploader ', home: UploaderList()));
    }
  }