import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UserGuideStepsList.dart';
  import 'UserGuideStepsProvider.dart';
  
  class UserGuideStepsPage extends StatelessWidget {
    const UserGuideStepsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UserGuideStepsProvider(),
          child: MaterialApp(title: 'UserGuideSteps ', home: UserGuideStepsList()));
    }
  }