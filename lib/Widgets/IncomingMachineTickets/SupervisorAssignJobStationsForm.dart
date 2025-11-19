import 'package:flutter/material.dart';

class SupervisorAssignJobStationsFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JobStationSelectionPage(),
    );
  }
}

class JobStationSelectionPage extends StatefulWidget {
  @override
  _JobStationSelectionPageState createState() =>
      _JobStationSelectionPageState();
}

class _JobStationSelectionPageState extends State<JobStationSelectionPage> {
  final List<Map<String, dynamic>> availableJobStations = [
    {'id': '1', 'name': 'Dismantling'},
    {'id': '2', 'name': 'Painting'},
    {'id': '3', 'name': 'Assembly'},
    {'id': '4', 'name': 'Modification'},
    {'id': '5', 'name': 'Body Works'},
  ];

  List<Map<String, dynamic>> selectedJobStations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Job Stations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: availableJobStations.map((station) {
                  return CheckboxListTile(
                    title: Text(station['name']),
                    value: selectedJobStations
                        .any((selected) => selected['id'] == station['id']),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedJobStations.add(station);
                        } else {
                          selectedJobStations.removeWhere(
                                  (selected) => selected['id'] == station['id']);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedJobStations.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                        Text('Please select at least one job station.')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobStationReorderPage(
                      selectedJobStations: selectedJobStations,
                    ),
                  ),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class JobStationReorderPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedJobStations;

  JobStationReorderPage({required this.selectedJobStations});

  @override
  _JobStationReorderPageState createState() => _JobStationReorderPageState();
}

class _JobStationReorderPageState extends State<JobStationReorderPage> {
  late List<Map<String, dynamic>> selectedJobStations;

  @override
  void initState() {
    super.initState();
    selectedJobStations = List.from(widget.selectedJobStations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reorder Job Stations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = selectedJobStations.removeAt(oldIndex);
                    selectedJobStations.insert(newIndex, item);
                  });
                },
                children: selectedJobStations
                    .map((station) => ListTile(
                  key: ValueKey(station['id']),
                  title: Text(station['name']),
                  trailing: Icon(Icons.drag_handle),
                ))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TechnicianAssignmentPage(
                          selectedJobStations: selectedJobStations,
                        ),
                      ),
                    );
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TechnicianAssignmentPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedJobStations;

  TechnicianAssignmentPage({required this.selectedJobStations});

  @override
  _TechnicianAssignmentPageState createState() =>
      _TechnicianAssignmentPageState();
}

class _TechnicianAssignmentPageState extends State<TechnicianAssignmentPage> {
  late List<Map<String, dynamic>> jobStations;

  final List<Map<String, dynamic>> technicians = [
    {'id': 'tech1', 'name': 'John Doe'},
    {'id': 'tech2', 'name': 'Jane Smith'},
    {'id': 'tech3', 'name': 'Sam Wilson'},
  ];

  @override
  void initState() {
    super.initState();
    jobStations = widget.selectedJobStations
        .map((station) => {...station, 'technicianId': null})
        .toList();
  }

  void saveAssignment() {
    if (jobStations.any((station) => station['technicianId'] == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('Please assign a technician to all job stations.')),
      );
      return;
    }

    print('Final Job Station Assignments: $jobStations');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Technicians Assigned Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assign Technicians')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: jobStations.map((station) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assign Technician for ${station['name']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      DropdownButtonFormField<String>(
                        value: station['technicianId'],
                        items: technicians
                            .map((tech) => DropdownMenuItem<String>(
                          value: tech['id'],
                          child: Text(tech['name']),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            station['technicianId'] = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Select Technician',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: saveAssignment,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
