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
import 'DepartmentAdmin.dart';
import 'DepartmentAdminService.dart';

class DepartmentAdminProvider with ChangeNotifier implements DataFetchable{
  List<DepartmentAdmin> _data = [];
  Box<DepartmentAdmin> hiveBox = Hive.box<DepartmentAdmin>('departmentAdminBox');
  List<DepartmentAdmin> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  DepartmentAdminProvider() {
    loadDepartmentAdminFromHive();
  }

  void loadDepartmentAdminFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(DepartmentAdmin item) async {
    _isLoading = true;
    final Result result = await DepartmentAdminService(query: query).create(item);
    if (result.error == null) {
      DepartmentAdmin? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentAdminFromHive();
      return Response(
          data: data,
          msg: "Success: Saved DepartmentAdmin",
          subClass: "DepartmentAdmin::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      DepartmentAdmin? data = result.data;
      logger.i("Failed: creating DepartmentAdmin::createOneAndSave, error: ${result.error}, subClass: DepartmentAdmin::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating DepartmentAdmin",
          subClass: "DepartmentAdmin::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await DepartmentAdminService(query: query).fetchById(id);
    if (result.error == null) {
      DepartmentAdmin? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentAdminFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "DepartmentAdmin::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: DepartmentAdmin::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching DepartmentAdmin $id", 
        error: result.error, 
        subClass: "DepartmentAdmin::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await DepartmentAdminService(query: query).fetchAll();
    if (result.error == null) {
      List<DepartmentAdmin>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((DepartmentAdmin item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadDepartmentAdminFromHive();
      return Response(
        msg: "Success: Fetched all DepartmentAdmin",
        subClass: "DepartmentAdmin::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DepartmentAdmin::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all DepartmentAdmin", 
        subClass: "DepartmentAdmin::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, DepartmentAdmin item) async {
    _isLoading = true;
    final Result result = await DepartmentAdminService().update(id, item);
    if (result.error == null) {
      DepartmentAdmin? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentAdminFromHive();
      return Response(
        msg: "Success: Updated DepartmentAdmin ${id}", 
        subClass: "DepartmentAdmin::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DepartmentAdmin::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating DepartmentAdmin ${id}",
        subClass: "DepartmentAdmin::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await DepartmentAdminService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadDepartmentAdminFromHive();
      return Response(
          msg: "Success: deleted DepartmentAdmin $id",
          subClass: "DepartmentAdmin::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("DepartmentAdmin::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting DepartmentAdmin $id",
      data : { "id" : $id },
      subClass: "DepartmentAdmin::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("DepartmentAdminSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of DepartmentAdmin",
          subClass: "DepartmentAdmin::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: DepartmentAdminSchema", 
      subClass: "DepartmentAdmin::schema",
      error: result.error);
    }
  }
}