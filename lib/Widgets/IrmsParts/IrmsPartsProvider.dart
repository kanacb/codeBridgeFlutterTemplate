import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'IrmsParts.dart';
import 'IrmsPartsService.dart';

class IrmsPartsProvider with ChangeNotifier {
  List<IrmsParts> _data = [];
  Box<IrmsParts> hiveBox = Hive.box<IrmsParts>('irmsPartsBox');
  List<IrmsParts> get data => _data;
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

  IrmsPartsProvider() {
    loadIrmsPartsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadIrmsPartsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(IrmsParts item) async {
    _isLoading = true;
    final Result result = await IrmsPartsService(query: query).create(item);
    if (result.error == null) {
      IrmsParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIrmsPartsFromHive();
      return Response(
          data: data,
          msg: "Success: created Job Station ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IrmsParts create : ${result.error}");
      return Response(
          msg: "Failed: creating Job Stations ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await IrmsPartsService(query: query).fetchById(id);
    if (result.error == null) {
      IrmsParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIrmsPartsFromHive();
      return Response(
          data: data,
          msg: "Success: saved Job Stations $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IrmsParts get one : ${result.error}");
      return Response(
          msg: "Failed: saving Job Stations $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await IrmsPartsService(query: query).fetchAll();
    if (result.error == null) {
      List<IrmsParts>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((IrmsParts item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadIrmsPartsFromHive();
      return Response(
          msg: "Success: fetched all Job Stations", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Job Stations get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Job Stations", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, IrmsParts item) async {
    _isLoading = true;
    final Result result = await IrmsPartsService().update(id, item);
    if (result.error == null) {
      IrmsParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIrmsPartsFromHive();
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
    final Result result = await IrmsPartsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadIrmsPartsFromHive();
      return Response(
          msg: "Success: deleted Job Stations $id",
          statusCode: result.statusCode);
    } else {
      logger.i("IrmsParts delete : ${result.error}");
      return Response(
          msg: "Failed: deleting Job Stations $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("irmsPartsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of IrmsParts",
          statusCode: result.statusCode);
    } else {
      logger.i("IrmsParts schema data: ${result.data}");
      logger.i("IrmsParts schema error: ${result.error}");
      return Response(
          msg: "Failed: IrmsPartsSchema", error: result.error);
    }
  }
}
