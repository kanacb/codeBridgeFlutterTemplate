import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Utils/Methods.dart';
import '../DataInitializer/DataFetchable.dart';
import '../../Utils/Services/SchemaService.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'ExternalChecks.dart';
import 'ExternalChecksService.dart';

class ExternalChecksProvider with ChangeNotifier implements DataFetchable{
  List<ExternalChecks> _data = [];
  Box<ExternalChecks> hiveBox = Hive.box<ExternalChecks>('externalChecksBox');
  List<ExternalChecks> get data => _data;
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

  ExternalChecksProvider() {
    loadExternalChecksFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadExternalChecksFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(ExternalChecks item) async {
    _isLoading = true;
    try {
      final Result result =
          await ExternalChecksService(query: query).create(item);
      if (result.error == null) {
        ExternalChecks? data = result.data;
        hiveBox.put(data?.id, data!);
        loadExternalChecksFromHive();
        return Response(
            data: data,
            msg: "Success: created external check ${item.name}",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("ExternalCheck create error: ${result.error}");
        return Response(
            msg: "Failed: creating external check ${item.name}",
            error: result.error);
      }
    } catch (e) {
      logger.i("ExternalCheck create error: ${e.toString()}");
      return Response(
          msg: "Failed: creating external check ${item.name}",
          error: e.toString());
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ExternalChecksService(query: query).fetchById(id);
    if (result.error == null) {
      ExternalChecks? data = result.data;
      hiveBox.put(data?.id, data!);
      loadExternalChecksFromHive();
      return Response(
          data: data,
          msg: "Success: saved external check $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("External Check get one : ${result.error}");
      return Response(
          msg: "Failed: saving external check $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ExternalChecksService(query: query).fetchAll();
    if (result.error == null) {
      List<ExternalChecks>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((ExternalChecks item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadExternalChecksFromHive();
      return Response(
          msg: "Success: fetched all external checks",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("External Checks get all error: ${result.error}");
      return Response(
          msg: "Failed: fetch all external checks", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, ExternalChecks item) async {
    _isLoading = true;
    final Result result = await ExternalChecksService().update(id, item);
    if (result.error == null) {
      ExternalChecks? data = result.data;
      hiveBox.put(data?.id, data!);
      loadExternalChecksFromHive();
      return Response(
          msg: "Success: updated external checks $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("External Checks update : ${result.error}");
      return Response(
          msg: "Failed: updating external checks $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ExternalChecksService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadExternalChecksFromHive();
      return Response(
          msg: "Success: deleted external checks $id",
          statusCode: result.statusCode);
    } else {
      logger.i("ExternalChecks delete : ${result.error}");
      return Response(
          msg: "Failed: deleting external check $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("externalChecksSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of external checks",
          statusCode: result.statusCode);
    } else {
      logger.i("ExternalChecks schema data: ${result.data}");
      logger.i("ExternalChecks schema error: ${result.error}");
      return Response(msg: "Failed: externalChecksSchema", error: result.error);
    }
  }

// Similar functions for `fetchOneAndSave`, `fetchAllAndSave`, `updateOneAndSave`, `deleteOne`, and `schema`
// following the same pattern as ExternalTicketProvider.
}
