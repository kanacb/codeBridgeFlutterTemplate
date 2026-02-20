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
import 'DepartmentHOD.dart';
import 'DepartmentHODService.dart';

class DepartmentHODProvider with ChangeNotifier implements DataFetchable{
  List<DepartmentHOD> _data = [];
  Box<DepartmentHOD> hiveBox = Hive.box<DepartmentHOD>('departmentHODBox');
  List<DepartmentHOD> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  DepartmentHODProvider() {
    loadDepartmentHODFromHive();
  }

  void loadDepartmentHODFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(DepartmentHOD item) async {
    _isLoading = true;
    final Result result = await DepartmentHODService(query: query).create(item);
    if (result.error == null) {
      DepartmentHOD? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentHODFromHive();
      return Response(
          data: data,
          msg: "Success: Saved DepartmentHOD",
          subClass: "DepartmentHOD::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      DepartmentHOD? data = result.data;
      logger.i("Failed: creating DepartmentHOD::createOneAndSave, error: ${result.error}, subClass: DepartmentHOD::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating DepartmentHOD",
          subClass: "DepartmentHOD::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await DepartmentHODService(query: query).fetchById(id);
    if (result.error == null) {
      DepartmentHOD? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentHODFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "DepartmentHOD::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: DepartmentHOD::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching DepartmentHOD $id", 
        error: result.error, 
        subClass: "DepartmentHOD::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await DepartmentHODService(query: query).fetchAll();
    if (result.error == null) {
      List<DepartmentHOD>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((DepartmentHOD item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadDepartmentHODFromHive();
      return Response(
        msg: "Success: Fetched all DepartmentHOD",
        subClass: "DepartmentHOD::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DepartmentHOD::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all DepartmentHOD", 
        subClass: "DepartmentHOD::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, DepartmentHOD item) async {
    _isLoading = true;
    final Result result = await DepartmentHODService().update(id, item);
    if (result.error == null) {
      DepartmentHOD? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentHODFromHive();
      return Response(
        msg: "Success: Updated DepartmentHOD ${id}", 
        subClass: "DepartmentHOD::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DepartmentHOD::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating DepartmentHOD ${id}",
        subClass: "DepartmentHOD::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await DepartmentHODService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadDepartmentHODFromHive();
      return Response(
          msg: "Success: deleted DepartmentHOD $id",
          subClass: "DepartmentHOD::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("DepartmentHOD::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting DepartmentHOD $id",
      data : { "id" : $id },
      subClass: "DepartmentHOD::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("DepartmentHODSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of DepartmentHOD",
          subClass: "DepartmentHOD::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: DepartmentHODSchema", 
      subClass: "DepartmentHOD::schema",
      error: result.error);
    }
  }
}