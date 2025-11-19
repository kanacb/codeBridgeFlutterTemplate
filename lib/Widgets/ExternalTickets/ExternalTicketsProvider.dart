import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'ExternalTickets.dart';
import 'ExternalTicketsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ExternalTicketsProvider with ChangeNotifier {
  List<ExternalTickets> _data = [];
  Box<ExternalTickets> hiveBox = Hive.box<ExternalTickets>('externalTicketsBox');
  List<ExternalTickets> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final String query;
  Map<String, dynamic> mapQuery = {
    "\$limit": 1000,
    "\$populate": [
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
      {
        "path": "externalUser",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "assignedSupervisor",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "assignedTechnician",
        "service": "profiles",
        "select": ["name"],
      },
    ],
  };

  ExternalTicketsProvider() {
    loadExternalTicketsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadExternalTicketsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(ExternalTickets item) async {
    _isLoading = true;
    final Result result = await ExternalTicketsService(query: query).create(item);
    if (result.error == null) {
      ExternalTickets? data = result.data;
      hiveBox.put(data?.id, data!);
      loadExternalTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: created external ticket ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ExternalTicket create : ${result.error}");
      return Response(
          msg: "Failed: creating external ticket ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ExternalTicketsService(query: query).fetchById(id);
    if (result.error == null) {
      ExternalTickets? data = result.data;
      hiveBox.put(data?.id, data!);
      loadExternalTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: saved external ticket $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("External Ticket get one : ${result.error}");
      return Response(msg: "Failed: saving external ticket $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ExternalTicketsService(query: query).fetchAll();
    if (result.error == null) {
      List<ExternalTickets>? data = result.data;

      if (data != null) {
        final fetchedIds = data.map((e) => e.id).toSet();
        final existingIds = hiveBox.keys.cast<String>().toSet();

        final idsToDelete = existingIds.difference(fetchedIds);
        for (var id in idsToDelete) {
          hiveBox.delete(id);
        }

        for (ExternalTickets item in data) {
          hiveBox.put(item.id, item);
        }
      }
      loadExternalTicketsFromHive();
      return Response(
          msg: "Success: fetched all external tickets", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ExternalTickets get all error: ${result.error}");
      return Response(msg: "Failed: fetch all external tickets", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, ExternalTickets item) async {
    _isLoading = true;
    final Result result = await ExternalTicketsService(query: query).update(id, item);
    if (result.error == null) {
      ExternalTickets? data = result.data;
      hiveBox.put(data?.id, data!);
      loadExternalTicketsFromHive();
      return Response(
          msg: "Success: updated external ticket $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ExternalTicket update : ${result.error}");
      return Response(msg: "Failed: updating external ticket $id", error: result.error);
    }
  }

  Future<Response> patchOneAndSave(String id, Map<String, dynamic> patchJSON) async {
    _isLoading = true;
    final Result result = await ExternalTicketsService(query: query).patch(id, patchJSON);
    if (result.error == null) {
      ExternalTickets? data = result.data;
      hiveBox.put(data?.id, data!);
      loadExternalTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: updated external ticket $id",
          statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("ExternalTicket update : ${result.error}");
      return Response(msg: "Failed: updating external ticket $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ExternalTicketsService(query: query).delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadExternalTicketsFromHive();
      return Response(
          msg: "Success: deleted external ticket $id", statusCode: result.statusCode);
    } else {
      logger.i("ExternalTicket delete : ${result.error}");
      return Response(msg: "Failed: deleting external ticket $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("externalTicketsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of external tickets",
          statusCode: result.statusCode);
    } else {
      logger.i("ExternalTicket schema data: ${result.data}");
      logger.i("ExternalTicket schema error: ${result.error}");
      return Response(msg: "Failed: externalTicketsSchema", error: result.error);
    }
  }
}
