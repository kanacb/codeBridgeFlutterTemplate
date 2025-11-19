import '../../Widgets/ExternalTickets/ExternalTicketsList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ExternalTicketsProvider.dart';

class ExternalTicketsPage extends StatelessWidget {
  final String? successMessage;

  const ExternalTicketsPage({super.key, this.successMessage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ExternalTicketsProvider(),
        child: MaterialApp(title: 'External App', home: ExternalTicketsList(successMessage: successMessage)));
  }
}