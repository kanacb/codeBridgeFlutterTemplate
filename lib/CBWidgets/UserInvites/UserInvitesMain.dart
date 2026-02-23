import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'UserInvitesList.dart';
  import 'UserInvitesProvider.dart';
  
  class UserInvitesPage extends StatelessWidget {
    const UserInvitesPage({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
          create: (context) => UserInvitesProvider(),
          child: MaterialApp(title: 'UserInvites ', home: UserInvitesList()));
    }
  }