import 'dart:convert';

import 'package:aims/App/Dash/Notifications/CBNotification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Utils/Methods.dart';
import '../../../Utils/Services/SharedPreferences.dart';
import '../../../Widgets/Users/User.dart';
import 'NotificationProvider.dart'; // Contains NotificationProvider & CBNotification

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NotificationProvider(),
        child: MaterialApp(title: 'Notification App', home: NotificationList()));
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<CBNotification> _userNotifications = [];
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _isLoading = true;
    });

    _user = User.fromJson(jsonDecode(await getPref("user") ?? ""));

    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    List<CBNotification> result = notificationProvider.notifications.reversed.toList();
    result = result.where((notification) => notification.toUser?.sId == _user?.id).toList();

    setState(() {
      _isLoading = false;
      _userNotifications = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Log the number of notifications loaded from the provider
    debugPrint("NotificationList build: ${_userNotifications.length} notifications loaded.");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement "Mark all as read" functionality.
              debugPrint("Mark all as read tapped");
            },
            child: const Text("Mark all as read"),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userNotifications.isEmpty
          ? const Center(child: Text("No notifications"))
          : _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _userNotifications.length,
      itemBuilder: (context, index) {
        final notification = _userNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(CBNotification notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: notification.read!
            ? const Icon(Icons.done, color: Colors.green)
            : const Icon(Icons.fiber_new, color: Colors.red),
        title: Text(
          "${notification.content} by ${notification.createdBy?.name}",
          style: TextStyle(
            fontWeight: notification.read! ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(
          Methods.formatDateTime(notification.sent!),
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: () {
          debugPrint("Notification tapped: ${notification.id}");
          // Optionally mark as read or navigate to a details screen
        },
      ),
    );
  }
}
