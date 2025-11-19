import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import '../../../Utils/Globals.dart' as globals;
import '../../../Utils/Methods.dart';
import '../../../Utils/Services/Response.dart';
import '../../../Utils/Services/Results.dart';
import 'CBNotification.dart';
import 'NotificationService.dart';

class NotificationProvider with ChangeNotifier {
  List<CBNotification> _notifications = [];
  Box<CBNotification> notificationBox = Hive.box<CBNotification>('notificationsBox');
  List<CBNotification> get notifications => _notifications;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";
  Map<String, dynamic> mapQuery = {
    "\$limit": 1000,
    "\$populate": [
      {
        "path": "toUser",
        "service": "users",
        "select": ["name"],
      },
      {
        "path": "createdBy",
        "service": "users",
        "select": ["name"],
      },
      {
        "path": "updatedBy",
        "service": "users",
        "select": ["name"],
      },
    ],
  };

  NotificationProvider() {
    loadNotificationFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadNotificationFromHive() {
    _isLoading = false;
    _notifications = notificationBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(CBNotification item) async {
    _isLoading = true;
    final Result result = await NotificationService(query: query).create(item);
    if (result.error == null) {
      CBNotification? data = result.data;
      notificationBox.put(data?.id, data!);
      loadNotificationFromHive();
      return Response(
          msg: "Success: created notification ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Notification create : ${result.error}");
      return Response(
          msg: "Failed: creating notification ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await NotificationService(query: query).fetchById(id);
    if (result.error == null) {
      CBNotification? data = result.data;
      notificationBox.put(data?.id, data!);
      loadNotificationFromHive();
      return Response(
          data: data,
          msg: "Success: saved notification $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Notification get one : ${result.error}");
      return Response(msg: "Failed: saving notification $id", error: result.error);
    }
  }

  Future<Response> fetchByToUserAndSave(String toUser) async {
    _isLoading = true;
    final Result result = await NotificationService(query: query).fetchByKeyValue("toUser", toUser);
    if (result.error == null) {
      List<CBNotification>? inboxes = result.data;

      inboxes
          ?.forEach((CBNotification notification) => notificationBox.put(notification.id, notification));
      loadNotificationFromHive();
      return Response(
        data: inboxes,
        msg: "Success: fetched by toUser",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("notifications fetch by toUser : ${result.error}");
      return Response(msg: "Failed: fetch by toUser", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await NotificationService(query: query).fetchAll();
    if (result.error == null) {
      List<CBNotification>? inboxes = result.data;

      inboxes
          ?.forEach((CBNotification notification) => notificationBox.put(notification.id, notification));
      loadNotificationFromHive();
      return Response(
          msg: "Success: fetched all", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("notifications get all : ${result.error}");
      return Response(msg: "Failed: fetch all", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, CBNotification item) async {
    _isLoading = true;
    final Result result = await NotificationService(query: query).update(id, item);
    if (result.error == null) {
      CBNotification? data = result.data;
      notificationBox.put(data?.id, data!);
      loadNotificationFromHive();
      return Response(
          msg: "Success: updated notification $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Notification update : ${result.error}");
      return Response(msg: "Failed: updating notification $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await NotificationService(query: query).delete(id);
    if (result.error == null) {
      notificationBox.delete(id);
      loadNotificationFromHive();
      return Response(
          msg: "Success: deleted notification $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Notification delete : ${result.error}");
      return Response(msg: "Failed: deleting notification $id", error: result.error);
    }
  }
}
