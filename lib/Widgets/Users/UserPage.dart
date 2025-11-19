import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/Users/UserList.dart';
import 'UserProvider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MaterialApp(title: 'User App', home: UserList()));
  }
}
