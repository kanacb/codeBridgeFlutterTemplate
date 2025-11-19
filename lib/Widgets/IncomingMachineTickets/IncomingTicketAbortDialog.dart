import 'dart:convert';

import 'package:aims/App/Dash/Notifications/CBNotification.dart';
import 'package:aims/App/Dash/Notifications/NotificationProvider.dart';
import 'package:aims/Widgets/IncomingMachineAbortHistory/IncomingMachineAbortHistory.dart';
import 'package:aims/Widgets/IncomingMachineAbortHistory/IncomingMachineAbortHistoryProvider.dart';
import 'package:aims/Widgets/IncomingMachineTickets/IncomingMachineTicket.dart';
import 'package:aims/Widgets/IncomingMachineTickets/IncomingMachineTicketProvider.dart';
import 'package:flutter/material.dart';

import '../../Utils/Services/IdName.dart';
import '../../Utils/Services/SharedPreferences.dart';
import '../Users/User.dart';

class IncomingTicketAbortDialog extends StatefulWidget {
  final IncomingMachineTicket ticket;
  final VoidCallback onUpdated;
  final VoidCallback onHide;

  const IncomingTicketAbortDialog({
    super.key,
    required this.ticket,
    required this.onUpdated,
    required this.onHide,
  });

  @override
  State<IncomingTicketAbortDialog> createState() => _IncomingTicketAbortDialogState();
}

class _IncomingTicketAbortDialogState extends State<IncomingTicketAbortDialog> {
  final _formKey = GlobalKey<FormState>();
  late final IncomingMachineTicket _ticket;
  late final User _user;
  final TextEditingController _reasonController = TextEditingController();

  Map<String, String> _errors = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _init() async {
    _ticket = widget.ticket;
    _user = User.fromJson(jsonDecode(await getPref("user") ?? ""));
  }

  Future<void> _onAbort() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      // patch IncomingMachineTicket
      final updatedData = {
        'status': 'Aborted',
        'endTime': DateTime.now().toUtc().toIso8601String(),
      };
      final patchResponse = await IncomingMachineTicketProvider().patchOneAndSave(_ticket.id!, updatedData);
      if (patchResponse.error != null) {
        throw Exception(patchResponse.error);
      }
      print("ticket patched");

      // create IncomingMachineAbortHistory
      final IncomingMachineAbortHistory incomingMachineAbortHistory = IncomingMachineAbortHistory(
        ticketId: _ticket.id,
        abortedBy: IdName(sId: _user.id, name: _user.name),
        abortReason: _reasonController.text,
        abortedAt: DateTime.now().toUtc(),
        machineId: _ticket.machineId,
        status: _ticket.status,
        createdBy: IdName(sId: _user.id, name: _user.name),
        updatedBy: IdName(sId: _user.id, name: _user.name),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      final createResponse = await IncomingMachineAbortHistoryProvider().createOneAndSave(incomingMachineAbortHistory);
      if (createResponse.error != null) {
        throw Exception(createResponse.error);
      }
      print("history created");

      // create notification
      final IncomingMachineTicket patchedTicket = patchResponse.data;
      final ticketJson = patchedTicket.toJsonWithId();
      final jsonString = jsonEncode(ticketJson);

      final CBNotification cbNotification = CBNotification(
        toUser: IdName(sId: _user.id, name: _user.name),
        content: "Incoming Machine Ticket with ID ${_ticket.id} was aborted. Reason: ${_reasonController.text}",
        path: "incomingMachineTickets",
        method: "patch",
        data: jsonString,
        recordId: _ticket.id,
        read: false,
        sent: DateTime.now().toUtc(),
        createdBy: IdName(sId: _user.id, name: _user.name),
        updatedBy: IdName(sId: _user.id, name: _user.name),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      final notificationResponse = await NotificationProvider().createOneAndSave(cbNotification);
      if (notificationResponse.error == null) {
        print("notification created");
        if (context.mounted) {
          widget.onHide();
          widget.onUpdated();
        }
      }
    } catch (err) {
      print('Error aborting ticket: $err');
      setState(() {
        _errors = {
          'form': err.toString().isNotEmpty
              ? err.toString()
              : 'An unexpected error occurred.'
        };
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
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to abort this ticket?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Mandatory reason input
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Reason is required';
                }
                return null;
              },
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
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => widget.onHide(),
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
