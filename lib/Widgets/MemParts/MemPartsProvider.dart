import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'MemParts.dart';
import 'MemPartsService.dart';

class MemPartsProvider with ChangeNotifier {
  List<MemParts> _data = [];
  Box<MemParts> hiveBox = Hive.box<MemParts>('memPartsBox');
  List<MemParts> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";
  Map<String, dynamic> mapQuery = {
    "\$limit": 25000,
    "\$populate": [
      {
        "path": "createdBy",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "updatedBy",
        "service": "profiles",
        "select": ["name"]
      }
    ],
  };

  MemPartsProvider() {
    loadMemPartsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadMemPartsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(MemParts item) async {
    _isLoading = true;
    final Result result = await MemPartsService(query: query).create(item);
    if (result.error == null) {
      MemParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMemPartsFromHive();
      return Response(
          data: data,
          msg: "Success: created Job Station ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MemParts create : ${result.error}");
      return Response(
          msg: "Failed: creating Job Stations ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await MemPartsService(query: query).fetchById(id);
    if (result.error == null) {
      MemParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMemPartsFromHive();
      return Response(
          data: data,
          msg: "Success: saved Job Stations $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MemParts get one : ${result.error}");
      return Response(
          msg: "Failed: saving Job Stations $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await MemPartsService(query: query).fetchAll();
    if (result.error == null) {
      List<MemParts>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((MemParts item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadMemPartsFromHive();
      return Response(
          msg: "Success: fetched all Job Stations", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Job Stations get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Job Stations", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, MemParts item) async {
    _isLoading = true;
    final Result result = await MemPartsService().update(id, item);
    if (result.error == null) {
      MemParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMemPartsFromHive();
      return Response(
          msg: "Success: updated Job Stations $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Job Stations update : ${result.error}");
      return Response(
          msg: "Failed: updating Job Stations $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await MemPartsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadMemPartsFromHive();
      return Response(
          msg: "Success: deleted Job Stations $id",
          statusCode: result.statusCode);
    } else {
      logger.i("MemParts delete : ${result.error}");
      return Response(
          msg: "Failed: deleting Job Stations $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("memPartsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of MemParts",
          statusCode: result.statusCode);
    } else {
      logger.i("MemParts schema data: ${result.data}");
      logger.i("MemParts schema error: ${result.error}");
      return Response(
          msg: "Failed: MemPartsSchema", error: result.error);
    }
  }
}
