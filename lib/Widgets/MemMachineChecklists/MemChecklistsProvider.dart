import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import '../DataInitializer/DataFetchable.dart';
import 'MemChecklists.dart';
import 'MemChecklistsService.dart';

class MemChecklistsProvider with ChangeNotifier implements DataFetchable {
  List<MemChecklists> _data = [];
  Box<MemChecklists> hiveBox = Hive.box<MemChecklists>('memChecklistsBox');
  List<MemChecklists> get data => _data;
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

  MemChecklistsProvider() {
    loadMemChecklistsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadMemChecklistsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(MemChecklists item) async {
    _isLoading = true;
    try {
      final Result result =
      await MemChecklistsService(query: query).create(item);
      if (result.error == null) {
        MemChecklists? data = result.data;
        hiveBox.put(data?.id, data!);
        loadMemChecklistsFromHive();
        return Response(
            data: data,
            msg: "Success: created incoming checklist ${item.id}",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("MemChecklists create error: ${result.error}");
        return Response(
            msg: "Failed: creating incoming checklist ${item.id}",
            error: result.error);
      }
    } catch (e) {
      logger.i("MemChecklists create error: ${e.toString()}");
      return Response(
          msg: "Failed: creating incoming checklist ${item.id}",
          error: e.toString());
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await MemChecklistsService(query: query).fetchById(id);
    if (result.error == null) {
      MemChecklists? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMemChecklistsFromHive();
      return Response(
          data: data,
          msg: "Success: saved incoming checklist $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MemChecklists get one : ${result.error}");
      return Response(msg: "Failed: saving incoming checklist $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await MemChecklistsService(query: query).fetchAll();

    if (result.error == null) {
      List<MemChecklists>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((MemChecklists item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadMemChecklistsFromHive();
      return Response(
          msg: "Success: fetched all incoming checklists", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MemChecklists get all error: ${result.error}");
      return Response(msg: "Failed: fetch all incoming checklists", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, MemChecklists item) async {
    _isLoading = true;
    final Result result = await MemChecklistsService().update(id, item);
    if (result.error == null) {
      MemChecklists? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMemChecklistsFromHive();
      return Response(
          msg: "Success: updated incoming checklist $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MemChecklists update : ${result.error}");
      return Response(msg: "Failed: updating incoming checklist $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await MemChecklistsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadMemChecklistsFromHive();
      return Response(
          msg: "Success: deleted incoming checklist $id", statusCode: result.statusCode);
    } else {
      logger.i("MemChecklists delete : ${result.error}");
      return Response(msg: "Failed: deleting incoming checklist $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("memChecklistsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of incoming checklists",
          statusCode: result.statusCode);
    } else {
      logger.i("MemChecklists schema data: ${result.data}");
      logger.i("MemChecklists schema error: ${result.error}");
      return Response(msg: "Failed: memChecklistsSchema", error: result.error);
    }
  }

}
