import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// A simplified Ticket model.
/// In a real app, extract this to a shared model file.
class Ticket {
  final String id;
  final String machineSerial;
  final String area;
  final List<String> issues;
  String? assignedTechnician;
  String status;
  List<File> images;

  Ticket({
    required this.id,
    required this.machineSerial,
    required this.area,
    required this.issues,
    this.assignedTechnician,
    this.status = 'Open',
    List<File>? images,
  }) : images = images ?? [];
}

class TechnicianTicketPage extends StatefulWidget {
  @override
  _TechnicianTicketPageState createState() => _TechnicianTicketPageState();
}

class _TechnicianTicketPageState extends State<TechnicianTicketPage> {
  // Dummy list of tickets assigned to the technician.
  List<Ticket> tickets = [
    Ticket(
      id: '1',
      machineSerial: 'M123',
      area: 'North',
      issues: ['Low coin intake', 'Display error'],
      assignedTechnician: 'Tech A',
      status: 'Assigned',
    ),
    Ticket(
      id: '3',
      machineSerial: 'M789',
      area: 'South',
      issues: ['Sensor malfunction'],
      assignedTechnician: 'Tech A',
      status: 'Assigned',
    ),
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(Ticket ticket) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        // In a real application, you might upload the image to your backend.
        ticket.images.add(File(pickedFile.path));
      });
    }
  }

  void closeTicket(Ticket ticket) {
    if (ticket.images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please upload at least one picture before closing the ticket.'),
        ),
      );
      return;
    }
    setState(() {
      ticket.status = 'Closed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket ${ticket.id} closed successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technician Ticket Management'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          Ticket ticket = tickets[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(
                  'Ticket ${ticket.id} - Machine: ${ticket.machineSerial}'),
              subtitle: Text('Status: ${ticket.status}'),
              children: [
                ListTile(
                  title: Text('Issues: ${ticket.issues.join(', ')}'),
                  subtitle:
                  Text('Images uploaded: ${ticket.images.length}'),
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        pickImage(ticket);
                      },
                      child: Text('Upload Picture'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        closeTicket(ticket);
                      },
                      child: Text('Close Ticket'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
