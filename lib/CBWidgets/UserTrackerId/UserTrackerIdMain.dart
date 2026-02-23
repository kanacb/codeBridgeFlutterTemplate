import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UserTrackerIdList.dart';
  import 'UserTrackerIdProvider.dart';
  
  class UserTrackerIdPage extends StatelessWidget {
    const UserTrackerIdPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UserTrackerIdProvider(),
          child: MaterialApp(title: 'UserTrackerId ', home: UserTrackerIdList()));
    }
  }