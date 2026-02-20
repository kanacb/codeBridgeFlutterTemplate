import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UserGuideList.dart';
  import 'UserGuideProvider.dart';
  
  class UserGuidePage extends StatelessWidget {
    const UserGuidePage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UserGuideProvider(),
          child: MaterialApp(title: 'UserGuide ', home: UserGuideList()));
    }
  }