import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Utils/Globals.dart' as globals;
import '../../../Utils/Services/Response.dart';
import '../../../Utils/Services/Results.dart';
import 'Inbox.dart';
import 'InboxService.dart';

class InboxProvider with ChangeNotifier {
  List<Inbox> _inboxes = [];
  // Using the same box name as in your HiveSetup ('inboxesBox')
  Box<Inbox> inboxBox = Hive.box<Inbox>('inboxesBox');
  List<Inbox> get inboxes => _inboxes;
  final logger = globals.logger;

  InboxProvider() {
    logger.d("InboxProvider created.");
    loadFromHive();
  }

  /// Loads all items from the Hive box and logs the keys and count.
  void loadFromHive() {
    final keys = inboxBox.keys.toList();
    logger.d("InboxProvider.loadFromHive: Found keys in Hive box: $keys");
    _inboxes = inboxBox.values.toList();
    logger.d("InboxProvider.loadFromHive: Loaded ${_inboxes.length} inbox items from Hive.");
    notifyListeners();
  }

  Future<Response> createOneAndSave(Inbox item) async {
    logger.d("Creating and saving inbox item with id: ${item.id}");
    final Result result = await InboxService().create(item);
    if (result.error == null) {
      Inbox data = result.data!;
      inboxBox.put(data.id, data);
      logger.d("Created inbox item with id: ${data.id}");
      loadFromHive();
      return Response(
        msg: "Success: created inbox ${item.sent}",
        statusCode: result.statusCode,
      );
    } else {
      logger.e("Failed to create inbox: ${result.error}");
      return Response(
        msg: "Failed: creating inbox ${item.sent}",
        error: result.error,
      );
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    logger.d("Fetching inbox item with id: $id");
    final Result result = await InboxService().fetchById(id);
    if (result.error == null) {
      Inbox data = result.data!;
      inboxBox.put(data.id, data);
      logger.d("Fetched and saved inbox item with id: ${data.id}");
      loadFromHive();
      return Response(
        msg: "Success: saved inbox $id",
        statusCode: result.statusCode,
      );
    } else {
      logger.e("Failed to fetch inbox item: ${result.error}");
      return Response(
        msg: "Failed: saving inbox $id",
        error: result.error,
      );
    }
  }

  Future<Response> fetchAllAndSave() async {
    final Result result = await InboxService().fetchAll();
    if (result.error == null) {
      // result.data is already a List<Inbox>
      List<Inbox> inboxesFromApi = result.data as List<Inbox>;

      // Save each inbox item to Hive
      for (Inbox inbox in inboxesFromApi) {
        inboxBox.put(inbox.id, inbox);
      }
      // Reload local list from Hive
      loadFromHive();

      return Response(
        msg: "Success: fetched all",
        statusCode: result.statusCode,
      );
    } else {
      logger.e("Error fetching inbox items: ${result.error}");
      return Response(
        msg: "Failed: fetch all",
        error: result.error,
      );
    }
  }



  Future<Response> updateOneAndSave(String id, Inbox item) async {
    logger.d("Updating inbox item with id: $id");
    final Result result = await InboxService().update(id, item);
    if (result.error == null) {
      Inbox data = result.data!;
      inboxBox.put(data.id, data);
      logger.d("Updated inbox item with id: ${data.id}");
      loadFromHive();
      return Response(
        msg: "Success: updated inbox $id",
        statusCode: result.statusCode,
      );
    } else {
      logger.e("Failed to update inbox: ${result.error}");
      return Response(
        msg: "Failed: updating inbox $id",
        error: result.error,
      );
    }
  }

  Future<Response> deleteOne(String id) async {
    logger.d("Deleting inbox item with id: $id");
    final Result result = await InboxService().delete(id);
    if (result.error == null) {
      inboxBox.delete(id);
      logger.d("Deleted inbox item with id: $id from Hive.");
      loadFromHive();
      return Response(
        msg: "Success: deleted inbox $id",
        statusCode: result.statusCode,
      );
    } else {
      logger.e("Failed to delete inbox: ${result.error}");
      return Response(
        msg: "Failed: deleting inbox $id",
        error: result.error,
      );
    }
  }
}
