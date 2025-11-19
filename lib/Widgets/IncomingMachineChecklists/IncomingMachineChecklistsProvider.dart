import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import '../DataInitializer/DataFetchable.dart';
import 'IncomingMachineChecklists.dart';
import 'IncomingMachineChecklistsService.dart';

class IncomingMachineChecklistsProvider with ChangeNotifier implements DataFetchable {
  List<IncomingMachineChecklists> _data = [];
  Box<IncomingMachineChecklists> hiveBox = Hive.box<IncomingMachineChecklists>('incomingMachineChecklistsBox');
  List<IncomingMachineChecklists> get data => _data;
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
    ],
  };

  IncomingMachineChecklistsProvider() {
    loadIncomingMachineChecklistsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadIncomingMachineChecklistsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(IncomingMachineChecklists item) async {
    _isLoading = true;
    try {
      final Result result =
      await IncomingMachineChecklistsService(query: query).create(item);
      if (result.error == null) {
        IncomingMachineChecklists? data = result.data;
        hiveBox.put(data?.id, data!);
        loadIncomingMachineChecklistsFromHive();
        return Response(
            data: data,
            msg: "Success: created incoming checklist ${item.id}",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("IncomingMachineChecklists create error: ${result.error}");
        return Response(
            msg: "Failed: creating incoming checklist ${item.id}",
            error: result.error);
      }
    } catch (e) {
      logger.i("IncomingMachineChecklists create error: ${e.toString()}");
      return Response(
          msg: "Failed: creating incoming checklist ${item.id}",
          error: e.toString());
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await IncomingMachineChecklistsService(query: query).fetchById(id);
    if (result.error == null) {
      IncomingMachineChecklists? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineChecklistsFromHive();
      return Response(
          data: data,
          msg: "Success: saved incoming checklist $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineChecklists get one : ${result.error}");
      return Response(msg: "Failed: saving incoming checklist $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await IncomingMachineChecklistsService(query: query).fetchAll();

    if (result.error == null) {
      List<IncomingMachineChecklists>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((IncomingMachineChecklists item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadIncomingMachineChecklistsFromHive();
      return Response(
          msg: "Success: fetched all incoming checklists", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineChecklists get all error: ${result.error}");
      return Response(msg: "Failed: fetch all incoming checklists", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, IncomingMachineChecklists item) async {
    _isLoading = true;
    final Result result = await IncomingMachineChecklistsService().update(id, item);
    if (result.error == null) {
      IncomingMachineChecklists? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineChecklistsFromHive();
      return Response(
          msg: "Success: updated incoming checklist $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineChecklists update : ${result.error}");
      return Response(msg: "Failed: updating incoming checklist $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await IncomingMachineChecklistsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadIncomingMachineChecklistsFromHive();
      return Response(
          msg: "Success: deleted incoming checklist $id", statusCode: result.statusCode);
    } else {
      logger.i("IncomingMachineChecklists delete : ${result.error}");
      return Response(msg: "Failed: deleting incoming checklist $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("incomingMachineChecklistsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of incoming checklists",
          statusCode: result.statusCode);
    } else {
      logger.i("IncomingMachineChecklists schema data: ${result.data}");
      logger.i("IncomingMachineChecklists schema error: ${result.error}");
      return Response(msg: "Failed: incomingMachineChecklistsSchema", error: result.error);
    }
  }

}
