import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:logger/logger.dart';
import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import '../../CBWidgets/DataInitializer/DataFetchable.dart';
import 'DepartmentHO.dart';
import 'DepartmentHOSService.dart';

class DepartmentHOSProvider with ChangeNotifier implements DataFetchable{
  List<DepartmentHO> _data = [];
  Box<DepartmentHO> hiveBox = Hive.box<DepartmentHO>('departmentHOSBox');
  List<DepartmentHO> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final String query;
  Map<String, dynamic> mapQuery = {
  "limit": 1000,
  "\$sort": {
    "createdAt": -1
  },
  "\$populate": []
};

  DepartmentHOSProvider() {
    loadDepartmentHOSFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadDepartmentHOSFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(DepartmentHO item) async {
    _isLoading = true;
    final Result result = await DepartmentHOSService(query: query).create(item);
    if (result.error == null) {
      DepartmentHO? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentHOSFromHive();
      return Response(
          data: data,
          msg: "Success: Saved DepartmentHOS",
          subClass: "DepartmentHOS::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      DepartmentHO? data = result.data;
      logger.i("Failed: creating DepartmentHOS::createOneAndSave, error: ${result.error}, subClass: DepartmentHOS::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating DepartmentHOS",
          subClass: "DepartmentHOS::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await DepartmentHOSService(query: query).fetchById(id);
    if (result.error == null) {
      DepartmentHO? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentHOSFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "DepartmentHOS::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: DepartmentHOS::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching DepartmentHOS $id", 
        error: result.error, 
        subClass: "DepartmentHOS::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await DepartmentHOSService(query: query).fetchAll();
    if (result.error == null) {
      List<DepartmentHO>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((DepartmentHO item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadDepartmentHOSFromHive();
      return Response(
        msg: "Success: Fetched all DepartmentHOS",
        subClass: "DepartmentHOS::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DepartmentHOS::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all DepartmentHOS", 
        subClass: "DepartmentHOS::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, DepartmentHO item) async {
    _isLoading = true;
    final Result result = await DepartmentHOSService().update(id, item);
    if (result.error == null) {
      DepartmentHO? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentHOSFromHive();
      return Response(
        msg: "Success: Updated DepartmentHOS ${id}", 
        subClass: "DepartmentHOS::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DepartmentHOS::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating DepartmentHOS ${id}",
        subClass: "DepartmentHOS::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await DepartmentHOSService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadDepartmentHOSFromHive();
      return Response(
          msg: "Success: deleted DepartmentHOS $id",
          subClass: "DepartmentHOS::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("DepartmentHOS::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting DepartmentHOS $id",
      data : { "id" : id.toString() },
      subClass: "DepartmentHOS::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("DepartmentHOSSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of DepartmentHOS",
          subClass: "DepartmentHOS::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: DepartmentHOSSchema", 
      subClass: "DepartmentHOS::schema",
      error: result.error);
    }
  }
}