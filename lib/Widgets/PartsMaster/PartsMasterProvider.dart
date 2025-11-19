import 'dart:convert';

import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'PartsMaster.dart';
import 'PartsMasterService.dart';

class PartsMasterProvider with ChangeNotifier {
  List<PartsMaster> _data = [];
  Box<PartsMaster> hiveBox = Hive.box<PartsMaster>('partsMastersBox');
  List<PartsMaster> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = """\$limit=10000""";

  PartsMasterProvider() {
    loadPartsMastersFromHive();
  }

  void loadPartsMastersFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(PartsMaster item) async {
    _isLoading = true;
    final Result result = await PartsMasterService(query: query).create(item);
    if (result.error == null) {
      PartsMaster? data = result.data;
      hiveBox.put(data?.itemNo, data!);
      loadPartsMastersFromHive();
      return Response(
          data: data,
          msg: "Success: created Parts master ${item.itemNo}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PartsMaster create : ${result.error}");
      return Response(
          msg: "Failed: creating Parts master ${item.itemNo}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await PartsMasterService(query: query).fetchById(id);
    if (result.error == null) {
      PartsMaster? data = result.data;
      hiveBox.put(data?.itemNo, data!);
      loadPartsMastersFromHive();
      return Response(
          data: data,
          msg: "Success: saved Parts master $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PartsMaster get one : ${result.error}");
      return Response(
          msg: "Failed: saving Parts master $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await PartsMasterService(query: query).fetchAll();
    if (result.error == null) {
      List<PartsMaster>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((PartsMaster item) {
        hiveBox.put(item.itemNo, item);
        if (isEmpty) _data.add(item);
      });
      loadPartsMastersFromHive();
      return Response(
          msg: "Success: fetched all Parts masters", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PartsMasters get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Parts masters", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, PartsMaster item) async {
    _isLoading = true;
    final Result result = await PartsMasterService().update(id, item);
    if (result.error == null) {
      PartsMaster? data = result.data;
      hiveBox.put(data?.itemNo,data!);
      loadPartsMastersFromHive();
      return Response(
          msg: "Success: updated Parts master $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PartsMaster update : ${result.error}");
      return Response(
          msg: "Failed: updating Parts master $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await PartsMasterService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadPartsMastersFromHive();
      return Response(
          msg: "Success: deleted Parts master $id",
          statusCode: result.statusCode);
    } else {
      logger.i("PartsMaster delete : ${result.error}");
      return Response(
          msg: "Failed: deleting Parts master $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("PartsMasterSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Parts masters",
          statusCode: result.statusCode);
    } else {
      logger.i("PartsMaster schema data: ${result.data}");
      logger.i("PartsMaster schema error: ${result.error}");
      return Response(
          msg: "Failed: PartsMastersSchema", error: result.error);
    }
  }
}
