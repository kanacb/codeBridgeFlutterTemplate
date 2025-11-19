import 'package:flutter/material.dart';

import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Methods.dart';
import 'JobStationTicket.dart';
import 'SingleJobStationTicketPage.dart';

class JobStationTicketPopUp extends StatefulWidget {
  final List<JobStationTicket> tickets;
  final dynamic incomingMachine;
  final Profile profile;

  const JobStationTicketPopUp({
    super.key,
    required this.tickets,
    required this.incomingMachine,
    required this.profile,
  });

  @override
  State<JobStationTicketPopUp> createState() => _JobStationTicketPopUpState();
}

class _JobStationTicketPopUpState extends State<JobStationTicketPopUp> {
  late final List<JobStationTicket> _tickets;
  late final dynamic _machine;
  late final Profile _profile;

  final List<bool> _showMore = List.filled(200, false, growable: true);

  @override
  void initState() {
    super.initState();
    _tickets = widget.tickets;
    _machine = widget.incomingMachine;
    _profile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: [
            Column(
              children: [
                _tickets.isEmpty
                    ? const Expanded(
                  child: Center(
                    child: Text('No tickets available'),
                  ),
                )
                    : Expanded(child: _buildTicketList(_tickets)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketList(List<JobStationTicket> tickets) {
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return _buildTicketCard(ticket, index);
      },
    );
  }

  Widget _buildTicketCard(JobStationTicket ticket, int index) {
    final statusColor = _getStatusColor(ticket.status);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SingleJobStationTicketPage(
                ticket: ticket,
                machine: _machine,
                profile: _profile,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(ticket.jobStationId ?? "-",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ticket.status ?? "Unknown",
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // MACHINE INFO
              Row(
                children: [
                  const Icon(Icons.settings, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Serial No: ${_machine?.serialNumber ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.settings, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Model: ${_machine?.modelNo ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Ownership: ${_machine?.ownership.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.category, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Type: ${_machine?.vendingMachineType?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.supervisor_account, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Supervisor: ${ticket.supervisorId?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Technician: ${ticket.technicianId?.name ?? "-"}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.play_arrow, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Start: ${Methods.formatDateTime(ticket.startTime)}")),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.stop, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text("End: ${Methods.formatDateTime(ticket.endTime, fallback: "In-Progress")}")),
                ],
              ),

              // Show more content
              _buildShowMoreContent(ticket, index),

              // Show More / Show Less button
              TextButton(
                onPressed: () => setState(() => _showMore[index] = !_showMore[index]),
                child: Text(
                  _showMore[index] ? 'Show less' : 'Show more',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Open': return Colors.orange;
      case 'In-Progress': return Colors.blue;
      case 'Aborted': return Colors.red;
      case 'Closed':
      case 'Resolved': return Colors.green;
      case 'Not Started': return Colors.grey;
      default: return Colors.grey;
    }
  }

  Widget _buildShowMoreContent(JobStationTicket ticket, int index) {
    if (!_showMore[index]) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Expanded(child: Text("Incoming Remarks: ${ticket.incomingRemarks ?? "-"}")),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.play_arrow, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Expanded(child: Text("Closing Remarks: ${ticket.jobCarriedOut ?? "-"}")),
          ],
        ),
      ],
    );
  }
}
