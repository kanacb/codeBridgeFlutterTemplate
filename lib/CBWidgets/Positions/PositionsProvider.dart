import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'Positions.dart';
import 'PositionsService.dart';

class PositionsProvider with ChangeNotifier {
  List<Positions> _data = [];
  Box<Positions> hiveBox = Hive.box<Positions>('positionsBox');
  List<Positions> get data => _data;
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
      },
      {
        "path": "roleId",
        "service": "roles",
        "select": ["name"]
      },
    ],
  };

  PositionsProvider() {
    loadPositionsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadPositionsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Positions item) async {
    _isLoading = true;
    final Result result = await PositionsService(query: query).create(item);
    if (result.error == null) {
      Positions? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPositionsFromHive();
      return Response(
          data: data,
          msg: "Success: created Job Station ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Positions create : ${result.error}");
      return Response(
          msg: "Failed: creating Positions ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchByNameAndSave(String name) async {
    _isLoading = true;
    final Result result = await PositionsService(query: query).fetchByKeyValue("name", name);
    if (result.error == null) {
      List<Positions>? data = result.data;
      if (data!.isNotEmpty) {
        for (var position in data) {
          hiveBox.put(position.id, position);
        }
      }
      loadPositionsFromHive();
      return Response(
          data: data,
          msg: "Success: saved Positions $name",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Positions get one : ${result.error}");
      return Response(
          msg: "Failed: saving Positions $name", error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await PositionsService(query: query).fetchById(id);
    if (result.error == null) {
      Positions? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPositionsFromHive();
      return Response(
          data: data,
          msg: "Success: saved Positions $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Positions get one : ${result.error}");
      return Response(
          msg: "Failed: saving Positions $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await PositionsService(query: query).fetchAll();
    if (result.error == null) {
      List<Positions>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Positions item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadPositionsFromHive();
      return Response(
          msg: "Success: fetched all Positions", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Positions get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Positions", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Positions item) async {
    _isLoading = true;
    final Result result = await PositionsService().update(id, item);
    if (result.error == null) {
      Positions? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPositionsFromHive();
      return Response(
          msg: "Success: updated Positions $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Positions update : ${result.error}");
      return Response(
          msg: "Failed: updating Positions $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await PositionsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadPositionsFromHive();
      return Response(
          msg: "Success: deleted Positions $id",
          statusCode: result.statusCode);
    } else {
      logger.i("Positions delete : ${result.error}");
      return Response(
          msg: "Failed: deleting Positions $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("positionsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Positions",
          statusCode: result.statusCode);
    } else {
      logger.i("Positions schema data: ${result.data}");
      logger.i("Positions schema error: ${result.error}");
      return Response(
          msg: "Failed: PositionsSchema", error: result.error);
    }
  }
}
