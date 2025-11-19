import '../../Widgets/ExternalChecks/ExternalChecksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'JobStationsList.dart';
import 'JobStationsProvider.dart';

class JobStationsPage extends StatelessWidget {
  const JobStationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => JobStationsProvider(),
        child: MaterialApp(title: 'Job Stations App', home: JobStationsList()));
  }
}