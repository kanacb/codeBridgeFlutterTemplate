import 'package:aims/Widgets/AtlasMachines/AtlasMachinesProvider.dart';

import '../../Widgets/AtlasTickets/AtlasTicketList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AtlasTicketProvider.dart';

class AtlasTicketPage extends StatelessWidget {
  final String? successMessage;

  const AtlasTicketPage({super.key, this.successMessage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AtlasTicketProvider()),
        ChangeNotifierProvider(create: (context) => AtlasMachinesProvider()),
      ],
      child: MaterialApp(title: 'Atlas App', home: AtlasTicketList(successMessage: successMessage)),
    );
  }
}
