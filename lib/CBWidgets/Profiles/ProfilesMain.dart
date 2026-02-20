import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'ProfilesList.dart';
  import 'ProfilesProvider.dart';
  
  class ProfilesPage extends StatelessWidget {
    const ProfilesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => ProfilesProvider(),
          child: MaterialApp(title: 'Profiles ', home: ProfilesList()));
    }
  }