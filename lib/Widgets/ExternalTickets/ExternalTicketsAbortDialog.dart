import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import 'ExternalTickets.dart';
import 'ExternalTicketsProvider.dart';

class ExternalTicketsAbortDialog extends StatefulWidget {
  final ExternalTickets ticket;
  final VoidCallback onUpdated;
  final VoidCallback onHide;

  const ExternalTicketsAbortDialog({
    super.key,
    required this.ticket,
    required this.onUpdated,
    required this.onHide,
  });

  @override
  State<ExternalTicketsAbortDialog> createState() => _ExternalTicketsAbortDialogState();
}

class _ExternalTicketsAbortDialogState extends State<ExternalTicketsAbortDialog> {
  Map<String, String> _errors = {};
  bool _loading = false;

  Future<void> _onAbort() async {
    setState(() {
      _loading = true;
    });

    try {
      final updatedData = {
        'status': 'Aborted',
        'endTime': DateTime.now().toUtc().toIso8601String(),
      };

      final Response responseTicket = await ExternalTicketsProvider().patchOneAndSave(widget.ticket.id!, updatedData);
      if(responseTicket.error == null) {
        if (context.mounted) {
          widget.onHide();
          widget.onUpdated();
        }
      }
    } catch (err) {
      print('Error aborting ticket: $err');
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
        'Abort Ticket',
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
            'Are you sure you want to abort this ticket?',
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
          onPressed: _loading ? null : _onAbort,
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
