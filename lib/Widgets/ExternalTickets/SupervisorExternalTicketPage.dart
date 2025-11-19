import 'package:flutter/material.dart';

/// A simplified Ticket model.
/// In a real app, you might have this in a shared file.
class Ticket {
  final String id;
  final String machineSerial;
  final String area;
  final List<String> issues;
  String? assignedTechnician;
  String status;

  Ticket({
    required this.id,
    required this.machineSerial,
    required this.area,
    required this.issues,
    this.assignedTechnician,
    this.status = 'Open',
  });
}

class SupervisorTicketPage extends StatefulWidget {
  @override
  _SupervisorTicketPageState createState() => _SupervisorTicketPageState();
}

class _SupervisorTicketPageState extends State<SupervisorTicketPage> {
  // Dummy list of tickets for demonstration.
  List<Ticket> tickets = [
    Ticket(
      id: '1',
      machineSerial: 'M123',
      area: 'North',
      issues: ['Low coin intake', 'Display error'],
    ),
    Ticket(
      id: '2',
      machineSerial: 'M456',
      area: 'North',
      issues: ['Paper jam'],
    ),
  ];

  // Dummy list of available technicians.
  List<String> technicians = ['Tech A', 'Tech B', 'Tech C'];

  void assignTechnician(Ticket ticket) async {
    String? selectedTech;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Assign Technician'),
          content: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Select Technician'),
            items: technicians.map((tech) {
              return DropdownMenuItem<String>(
                value: tech,
                child: Text(tech),
              );
            }).toList(),
            onChanged: (value) {
              selectedTech = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTech != null) {
                  setState(() {
                    ticket.assignedTechnician = selectedTech;
                    ticket.status = 'Assigned';
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supervisor Ticket Management'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          Ticket ticket = tickets[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                  'Ticket ${ticket.id} - Machine: ${ticket.machineSerial}'),
              subtitle: Text(
                  'Area: ${ticket.area}\nIssues: ${ticket.issues.join(', ')}\nStatus: ${ticket.status}\nAssigned Technician: ${ticket.assignedTechnician ?? 'None'}'),
              trailing: ticket.assignedTechnician == null
                  ? ElevatedButton(
                onPressed: () {
                  assignTechnician(ticket);
                },
                child: Text('Assign'),
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
