import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'MenuItemsList.dart';
  import 'MenuItemsProvider.dart';
  
  class MenuItemsPage extends StatelessWidget {
    const MenuItemsPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => MenuItemsProvider(),
          child: MaterialApp(title: 'MenuItems ', home: MenuItemsList()));
    }
  }