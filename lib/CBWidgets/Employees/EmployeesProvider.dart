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
import 'Employee.dart';
import 'EmployeesService.dart';

class EmployeesProvider with ChangeNotifier implements DataFetchable{
  List<Employee> _data = [];
  Box<Employee> hiveBox = Hive.box<Employee>('employeesBox');
  List<Employee> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  EmployeesProvider() {
    loadEmployeesFromHive();
  }

  void loadEmployeesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Employee item) async {
    _isLoading = true;
    final Result result = await EmployeesService(query: query).create(item);
    if (result.error == null) {
      Employee? data = result.data;
      hiveBox.put(data?.id, data!);
      loadEmployeesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Employees",
          subClass: "Employees::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Employee? data = result.data;
      logger.i("Failed: creating Employees::createOneAndSave, error: ${result.error}, subClass: Employees::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Employees",
          subClass: "Employees::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await EmployeesService(query: query).fetchById(id);
    if (result.error == null) {
      Employee? data = result.data;
      hiveBox.put(data?.id, data!);
      loadEmployeesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Employees::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Employees::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Employees $id", 
        error: result.error, 
        subClass: "Employees::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await EmployeesService(query: query).fetchAll();
    if (result.error == null) {
      List<Employee>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Employee item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadEmployeesFromHive();
      return Response(
        msg: "Success: Fetched all Employees",
        subClass: "Employees::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Employees::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Employees", 
        subClass: "Employees::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Employee item) async {
    _isLoading = true;
    final Result result = await EmployeesService().update(id, item);
    if (result.error == null) {
      Employee? data = result.data;
      hiveBox.put(data?.id, data!);
      loadEmployeesFromHive();
      return Response(
        msg: "Success: Updated Employees ${id}", 
        subClass: "Employees::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Employees::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Employees ${id}",
        subClass: "Employees::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await EmployeesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadEmployeesFromHive();
      return Response(
          msg: "Success: deleted Employees $id",
          subClass: "Employees::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Employees::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Employees $id",
      data : { "id" : id.toString() },
      subClass: "Employees::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("EmployeesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Employees",
          subClass: "Employees::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: EmployeesSchema", 
      subClass: "Employees::schema",
      error: result.error);
    }
  }
}