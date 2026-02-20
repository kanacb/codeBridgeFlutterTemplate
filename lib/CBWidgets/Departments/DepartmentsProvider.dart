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
import 'Department.dart';
import 'DepartmentsService.dart';

class DepartmentsProvider with ChangeNotifier implements DataFetchable{
  List<Department> _data = [];
  Box<Department> hiveBox = Hive.box<Department>('departmentsBox');
  List<Department> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  DepartmentsProvider() {
    loadDepartmentsFromHive();
  }

  void loadDepartmentsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Department item) async {
    _isLoading = true;
    final Result result = await DepartmentsService(query: query).create(item);
    if (result.error == null) {
      Department? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Departments",
          subClass: "Departments::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Department? data = result.data;
      logger.i("Failed: creating Departments::createOneAndSave, error: ${result.error}, subClass: Departments::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Departments",
          subClass: "Departments::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await DepartmentsService(query: query).fetchById(id);
    if (result.error == null) {
      Department? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Departments::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Departments::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Departments $id", 
        error: result.error, 
        subClass: "Departments::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await DepartmentsService(query: query).fetchAll();
    if (result.error == null) {
      List<Department>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Department item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadDepartmentsFromHive();
      return Response(
        msg: "Success: Fetched all Departments",
        subClass: "Departments::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Departments::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Departments", 
        subClass: "Departments::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Department item) async {
    _isLoading = true;
    final Result result = await DepartmentsService().update(id, item);
    if (result.error == null) {
      Department? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDepartmentsFromHive();
      return Response(
        msg: "Success: Updated Departments ${id}", 
        subClass: "Departments::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Departments::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Departments ${id}",
        subClass: "Departments::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await DepartmentsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadDepartmentsFromHive();
      return Response(
          msg: "Success: deleted Departments $id",
          subClass: "Departments::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Departments::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Departments $id",
      data : { "id" : id.toString() },
      subClass: "Departments::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("DepartmentsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Departments",
          subClass: "Departments::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: DepartmentsSchema", 
      subClass: "Departments::schema",
      error: result.error);
    }
  }
}