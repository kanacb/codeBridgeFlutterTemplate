import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../DataInitializer/DataFetchable.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'ExternalChecklists.dart';
import 'ExternalChecklistsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ExternalChecklistsProvider with ChangeNotifier implements DataFetchable{
  List<ExternalChecklists> _data = [];
  Box<ExternalChecklists> hiveBox =
  Hive.box<ExternalChecklists>('externalChecklistsBox');
  List<ExternalChecklists> get data => _data;
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
        "path": "vendingMachineId",
        "service": "vendingMachines",
        "select": ["name"],
      },
    ],
  };

  ExternalChecklistsProvider() {
    loadExternalChecklistsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadExternalChecklistsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(ExternalChecklists item) async {
    _isLoading = true;
    try {
      final Result result =
      await ExternalChecklistsService(query: query).create(item);
      if (result.error == null) {
        ExternalChecklists? data = result.data;
        hiveBox.put(data?.id, data!);
        loadExternalChecklistsFromHive();
        return Response(
            data: data,
            msg: "Success: created external checklist ${item.name}",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("ExternalChecklist create error: ${result.error}");
        return Response(
            msg: "Failed: creating external checklist ${item.name}",
            error: result.error);
      }
    } catch (e) {
      logger.i("ExternalChecklist create error: ${e.toString()}");
      return Response(
          msg: "Failed: creating external checklist ${item.name}",
          error: e.toString());
    }
  }
  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    try {
      final Result result =
      await ExternalChecklistsService(query: query).fetchById(id);
      if (result.error == null) {
        ExternalChecklists? data = result.data;
        hiveBox.put(data?.id, data!);
        loadExternalChecklistsFromHive();
        return Response(
            data: data,
            msg: "Success: saved external ticket $id",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("ExternalTicket fetchOneAndSave error: ${result.error}");
        return Response(
            msg: "Failed: saving external ticket $id", error: result.error);
      }
    } catch (e) {
      logger.i("ExternalTicket fetchOneAndSave error: ${e.toString()}");
      return Response(
          msg: "Failed: saving external ticket $id", error: e.toString());
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    try {
      final Result result =
      await ExternalChecklistsService(query: query).fetchAll();
      if (result.error == null) {
        List<ExternalChecklists>? data = result.data;
        var isEmpty = false;
        if (_data.isEmpty) isEmpty = true;
        data?.forEach((ExternalChecklists item) {
          hiveBox.put(item.id, item);
          if (isEmpty) _data.add(item);
        });
        loadExternalChecklistsFromHive();
        return Response(
            msg: "Success: fetched all external tickets",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("ExternalTickets fetchAllAndSave error: ${result.error}");
        return Response(
            msg: "Failed: fetch all external tickets", error: result.error);
      }
    } catch (e) {
      logger.i("ExternalTickets fetchAllAndSave error: ${e.toString()}");
      return Response(
          msg: "Failed: fetch all external tickets", error: e.toString());
    }
  }

  Future<Response> updateOneAndSave(String id, ExternalChecklists item) async {
    _isLoading = true;
    try {
      final Result result =
      await ExternalChecklistsService().update(id, item);
      if (result.error == null) {
        ExternalChecklists? data = result.data;
        hiveBox.put(data?.id, data!);
        loadExternalChecklistsFromHive();
        return Response(
            msg: "Success: updated external ticket $id",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("ExternalTicket update error: ${result.error}");
        return Response(
            msg: "Failed: updating external ticket $id", error: result.error);
      }
    } catch (e) {
      logger.i("ExternalTicket update error: ${e.toString()}");
      return Response(
          msg: "Failed: updating external ticket $id", error: e.toString());
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    try {
      final Result result =
      await ExternalChecklistsService().delete(id);
      _isLoading = false;
      if (result.error == null) {
        hiveBox.delete(id);
        loadExternalChecklistsFromHive();
        return Response(
            msg: "Success: deleted external ticket $id",
            statusCode: result.statusCode);
      } else {
        logger.i("ExternalTicket delete error: ${result.error}");
        return Response(
            msg: "Failed: deleting external ticket $id", error: result.error);
      }
    } catch (e) {
      logger.i("ExternalTicket delete error: ${e.toString()}");
      return Response(
          msg: "Failed: deleting external ticket $id", error: e.toString());
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    try {
      final Result result =
      await SchemaService().schema("externalChecklistsSchema");
      _isLoading = false;
      if (result.error == null) {
        return Response(
            data: result.data,
            msg: "Success: schema of external Checklists",
            statusCode: result.statusCode);
      } else {
        logger.i("External Checklists schema error: ${result.error}");
        return Response(
            msg: "Failed: External Checklists Schema", error: result.error);
      }
    } catch (e) {
      logger.i("External Checklists schema error: ${e.toString()}");
      return Response(
          msg: "Failed: externalChecklistsSchema", error: e.toString());
    }
  }

}
