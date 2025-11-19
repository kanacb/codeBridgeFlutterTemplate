import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import 'IncomingMachineTicket.dart';
import 'IncomingMachineTicketProvider.dart';

class IncomingTicketCloseDialog extends StatefulWidget {
  final IncomingMachineTicket ticket;
  final VoidCallback onUpdated;
  final VoidCallback onHide;

  const IncomingTicketCloseDialog({
    super.key,
    required this.ticket,
    required this.onUpdated,
    required this.onHide,
  });

  @override
  State<IncomingTicketCloseDialog> createState() => _IncomingTicketCloseDialogState();
}

class _IncomingTicketCloseDialogState extends State<IncomingTicketCloseDialog> {
  Map<String, String> _errors = {};
  bool _loading = false;

  Future<void> _onClose() async {
    setState(() {
      _loading = true;
    });

    try {
      final updatedData = {
        'status': 'Closed',
        'endTime': DateTime.now().toUtc().toIso8601String(),
      };

      final Response responseTicket = await IncomingMachineTicketProvider().patchOneAndSave(widget.ticket.id!, updatedData);
      if(responseTicket.error == null) {
        if (context.mounted) {
          widget.onHide();
          widget.onUpdated();
        }
      }
    } catch (err) {
      print('Error closing ticket: $err');
      setState(() {
        _errors = {'form': err.toString().isNotEmpty ? err.toString() : 'An unexpected error occurred.'};
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Close Ticket',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you sure you want to close this ticket?',
            style: TextStyle(fontSize: 16),
          ),
          // Form error message
          if (_errors.containsKey('form'))
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errors['form']!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () {widget.onHide();},
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _onClose,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: _loading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Confirm'),
        ),
      ],
    );
  }
}
