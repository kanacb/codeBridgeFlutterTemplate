import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'IncomingMachineAbortHistory.dart';
import 'IncomingMachineAbortHistoryService.dart';

class IncomingMachineAbortHistoryProvider with ChangeNotifier {
  List<IncomingMachineAbortHistory> _data = [];
  Box<IncomingMachineAbortHistory> hiveBox = Hive.box<IncomingMachineAbortHistory>('incomingMachineAbortHistoryBox');
  List<IncomingMachineAbortHistory> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";
  Map<String, dynamic> mapQuery = {
    "\$limit": 1000,
    "\$populate": [
      {
        "path": "abortedBy",
        "service": "profiles",
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

  IncomingMachineAbortHistoryProvider() {
    loadIncomingMachineAbortHistoryFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadIncomingMachineAbortHistoryFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(IncomingMachineAbortHistory item) async {
    _isLoading = true;
    final Result result = await IncomingMachineAbortHistoryService(query: query).create(item);
    if (result.error == null) {
      IncomingMachineAbortHistory? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineAbortHistoryFromHive();
      return Response(
          data: data,
          msg: "Success: created Job Station ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineAbortHistory create : ${result.error}");
      return Response(
          msg: "Failed: creating IncomingMachineAbortHistory ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await IncomingMachineAbortHistoryService(query: query).fetchById(id);
    if (result.error == null) {
      IncomingMachineAbortHistory? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineAbortHistoryFromHive();
      return Response(
          data: data,
          msg: "Success: saved IncomingMachineAbortHistory $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineAbortHistory get one : ${result.error}");
      return Response(
          msg: "Failed: saving IncomingMachineAbortHistory $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await IncomingMachineAbortHistoryService(query: query).fetchAll();
    if (result.error == null) {
      List<IncomingMachineAbortHistory>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((IncomingMachineAbortHistory item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadIncomingMachineAbortHistoryFromHive();
      return Response(
          msg: "Success: fetched all IncomingMachineAbortHistory", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineAbortHistory get all error: ${result.error}");
      return Response(msg: "Failed: fetch all IncomingMachineAbortHistory", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, IncomingMachineAbortHistory item) async {
    _isLoading = true;
    final Result result = await IncomingMachineAbortHistoryService().update(id, item);
    if (result.error == null) {
      IncomingMachineAbortHistory? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineAbortHistoryFromHive();
      return Response(
          msg: "Success: updated IncomingMachineAbortHistory $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineAbortHistory update : ${result.error}");
      return Response(
          msg: "Failed: updating IncomingMachineAbortHistory $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await IncomingMachineAbortHistoryService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadIncomingMachineAbortHistoryFromHive();
      return Response(
          msg: "Success: deleted IncomingMachineAbortHistory $id",
          statusCode: result.statusCode);
    } else {
      logger.i("IncomingMachineAbortHistory delete : ${result.error}");
      return Response(
          msg: "Failed: deleting IncomingMachineAbortHistory $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("incomingMachineAbortHistorySchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of IncomingMachineAbortHistory",
          statusCode: result.statusCode);
    } else {
      logger.i("IncomingMachineAbortHistory schema data: ${result.data}");
      logger.i("IncomingMachineAbortHistory schema error: ${result.error}");
      return Response(
          msg: "Failed: IncomingMachineAbortHistorySchema", error: result.error);
    }
  }
}
