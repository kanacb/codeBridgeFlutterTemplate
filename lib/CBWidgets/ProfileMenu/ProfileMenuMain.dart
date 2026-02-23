import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'ProfileMenuList.dart';
  import 'ProfileMenuProvider.dart';
  
  class ProfileMenuPage extends StatelessWidget {
    const ProfileMenuPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => ProfileMenuProvider(),
          child: MaterialApp(title: 'ProfileMenu ', home: ProfileMenuList()));
    }
  }