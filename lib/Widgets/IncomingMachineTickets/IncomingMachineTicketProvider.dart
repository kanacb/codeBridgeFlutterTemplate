import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'IncomingMachineTicket.dart';
import 'IncomingMachineTicketService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IncomingMachineTicketProvider with ChangeNotifier {
  List<IncomingMachineTicket> _data = [];
  Box<IncomingMachineTicket> hiveBox = Hive.box<IncomingMachineTicket>('incomingMachineTicketsBox');
  List<IncomingMachineTicket> get data => _data;
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
        "path": "assignedSupervisor",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "incomingMachineChecker",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "selectedJobStations.technicianId",
        "service": "profiles",
        "select": ["name"]
      },
      {
        "path": "vendingControllerChecklistResponse.checkListId",
        "service": "incomingMachineChecklists",
        "select": ["name"]
      }
    ],
  };

  IncomingMachineTicketProvider() {
    loadIncomingMachineTicketsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadIncomingMachineTicketsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(IncomingMachineTicket item) async {
    _isLoading = true;
    final Result result = await IncomingMachineTicketService(query: query).create(item);
    if (result.error == null) {
      IncomingMachineTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: created IncomingMachine ticket ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineTicket create : ${result.error}");
      return Response(
          msg: "Failed: creating IncomingMachine ticket ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await IncomingMachineTicketService(query: query).fetchById(id);
    if (result.error == null) {
      IncomingMachineTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: saved IncomingMachine ticket $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineTicket get one : ${result.error}");
      return Response(msg: "Failed: saving IncomingMachine ticket $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await IncomingMachineTicketService(query: query).fetchAll();
    if (result.error == null) {
      List<IncomingMachineTicket>? data = result.data;

      if (data != null) {
        final fetchedIds = data.map((e) => e.id).toSet();
        final existingIds = hiveBox.keys.cast<String>().toSet();

        final idsToDelete = existingIds.difference(fetchedIds);
        for (var id in idsToDelete) {
          hiveBox.delete(id);
        }

        for (IncomingMachineTicket item in data) {
          hiveBox.put(item.id, item);
        }
      }
      loadIncomingMachineTicketsFromHive();
      return Response(
          msg: "Success: fetched all IncomingMachine tickets", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachine get all error: ${result.error}");
      return Response(msg: "Failed: fetch all IncomingMachine tickets", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, IncomingMachineTicket item) async {
    _isLoading = true;
    final Result result = await IncomingMachineTicketService().update(id, item);
    if (result.error == null) {
      IncomingMachineTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineTicketsFromHive();
      return Response(
          msg: "Success: updated IncomingMachine ticket $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineTicket update : ${result.error}");
      return Response(msg: "Failed: updating IncomingMachine ticket $id", error: result.error);
    }
  }

  Future<Response> patchOneAndSave(String id, Map<String, dynamic> patchJSON) async {
    _isLoading = true;
    final Result result = await IncomingMachineTicketService(
      query: query,
    ).patch(id, patchJSON);
    if (result.error == null) {
      IncomingMachineTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineTicketsFromHive();
      return Response(
        data: data,
        msg: "Success: updated incoming machine ticket $id",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("IncomingMachineTicket update : ${result.error}");
      return Response(
        msg: "Failed: updating incoming machine ticket $id",
        error: result.error,
      );
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await IncomingMachineTicketService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadIncomingMachineTicketsFromHive();
      return Response(
          msg: "Success: deleted Incoming Machine ticket $id", statusCode: result.statusCode);
    } else {
      logger.i("Incoming Machine Ticket delete : ${result.error}");
      return Response(msg: "Failed: deleting Incoming Machine ticket $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("IncomingMachineTicketsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Incoming Machine tickets",
          statusCode: result.statusCode
      );
    } else {
      logger.i("Incoming Machine Ticket schema data: ${result.data}");
      logger.i("Incoming Machine Ticket schema error: ${result.error}");
      return Response(msg: "Failed: Incoming Machine TicketsSchema", error: result.error);
    }
  }
}
