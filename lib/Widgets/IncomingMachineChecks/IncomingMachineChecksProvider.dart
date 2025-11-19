import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import '../DataInitializer/DataFetchable.dart';
import 'IncomingMachineChecks.dart';
import 'IncomingMachineChecksService.dart';

class IncomingMachineChecksProvider with ChangeNotifier implements DataFetchable {
  List<IncomingMachineChecks> _data = [];
  Box<IncomingMachineChecks> hiveBox = Hive.box<IncomingMachineChecks>('incomingMachineChecksBox');
  List<IncomingMachineChecks> get data => _data;
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

  IncomingMachineChecksProvider() {
    loadIncomingMachineChecksFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadIncomingMachineChecksFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(IncomingMachineChecks item) async {
    _isLoading = true;
    try {
      final Result result =
      await IncomingMachineChecksService(query: query).create(item);
      if (result.error == null) {
        IncomingMachineChecks? data = result.data;
        hiveBox.put(data?.id, data!);
        loadIncomingMachineChecksFromHive();
        return Response(
            data: data,
            msg: "Success: created incoming check ${item.id}",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("IncomingMachineChecks create error: ${result.error}");
        return Response(
            msg: "Failed: creating incoming check ${item.id}",
            error: result.error);
      }
    } catch (e) {
      logger.i("IncomingMachineChecks create error: ${e.toString()}");
      return Response(
          msg: "Failed: creating incoming check ${item.id}",
          error: e.toString());
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await IncomingMachineChecksService(query: query).fetchById(id);
    if (result.error == null) {
      IncomingMachineChecks? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineChecksFromHive();
      return Response(
          data: data,
          msg: "Success: saved incoming check $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineChecks get one : ${result.error}");
      return Response(msg: "Failed: saving incoming check $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await IncomingMachineChecksService(query: query).fetchAll();

    if (result.error == null) {
      List<IncomingMachineChecks>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((IncomingMachineChecks item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadIncomingMachineChecksFromHive();
      return Response(
          msg: "Success: fetched all incoming checks", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Incoming checks get all error: ${result.error}");
      return Response(msg: "Failed: fetch all incoming checks", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, IncomingMachineChecks item) async {
    _isLoading = true;
    final Result result = await IncomingMachineChecksService().update(id, item);
    if (result.error == null) {
      IncomingMachineChecks? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIncomingMachineChecksFromHive();
      return Response(
          msg: "Success: updated incoming check $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IncomingMachineChecks update : ${result.error}");
      return Response(msg: "Failed: updating incoming check $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await IncomingMachineChecksService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadIncomingMachineChecksFromHive();
      return Response(
          msg: "Success: deleted incoming check $id", statusCode: result.statusCode);
    } else {
      logger.i("IncomingMachineChecks delete : ${result.error}");
      return Response(msg: "Failed: deleting incoming check $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("incomingMachineChecksSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of incoming checks",
          statusCode: result.statusCode);
    } else {
      logger.i("IncomingMachineChecks schema data: ${result.data}");
      logger.i("IncomingMachineChecks schema error: ${result.error}");
      return Response(msg: "Failed: incomingMachineChecksSchema", error: result.error);
    }
  }

}
