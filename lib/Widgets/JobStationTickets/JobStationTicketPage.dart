import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'JobStationTicketList.dart';
import 'JobStationTicketProvider.dart';

class JobStationTicketPage extends StatelessWidget {
  const JobStationTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => JobStationTicketProvider(),
        child: MaterialApp(title: 'Job Stations App', home: JobStationTicketList()));
  }
}