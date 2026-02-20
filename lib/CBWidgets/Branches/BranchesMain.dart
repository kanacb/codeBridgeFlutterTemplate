import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'BranchesList.dart';
  import 'BranchesProvider.dart';
  
  class BranchesPage extends StatelessWidget {
    const BranchesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => BranchesProvider(),
          child: MaterialApp(title: 'Branches ', home: BranchesList()));
    }
  }