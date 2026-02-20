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
import 'Roles.dart';
import 'RolesService.dart';

class RolesProvider with ChangeNotifier implements DataFetchable{
  List<Roles> _data = [];
  Box<Roles> hiveBox = Hive.box<Roles>('rolesBox');
  List<Roles> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  RolesProvider() {
    loadRolesFromHive();
  }

  void loadRolesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Roles item) async {
    _isLoading = true;
    final Result result = await RolesService(query: query).create(item);
    if (result.error == null) {
      Roles? data = result.data;
      hiveBox.put(data?.id, data!);
      loadRolesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Roles",
          subClass: "Roles::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Roles? data = result.data;
      logger.i("Failed: creating Roles::createOneAndSave, error: ${result.error}, subClass: Roles::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Roles",
          subClass: "Roles::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await RolesService(query: query).fetchById(id);
    if (result.error == null) {
      Roles? data = result.data;
      hiveBox.put(data?.id, data!);
      loadRolesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Roles::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Roles::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Roles $id", 
        error: result.error, 
        subClass: "Roles::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await RolesService(query: query).fetchAll();
    if (result.error == null) {
      List<Roles>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Roles item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadRolesFromHive();
      return Response(
        msg: "Success: Fetched all Roles",
        subClass: "Roles::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Roles::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Roles", 
        subClass: "Roles::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Roles item) async {
    _isLoading = true;
    final Result result = await RolesService().update(id, item);
    if (result.error == null) {
      Roles? data = result.data;
      hiveBox.put(data?.id, data!);
      loadRolesFromHive();
      return Response(
        msg: "Success: Updated Roles ${id}", 
        subClass: "Roles::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Roles::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Roles ${id}",
        subClass: "Roles::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await RolesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadRolesFromHive();
      return Response(
          msg: "Success: deleted Roles $id",
          subClass: "Roles::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Roles::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Roles $id",
      data : { "id" : id.toString() },
      subClass: "Roles::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("RolesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Roles",
          subClass: "Roles::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: RolesSchema", 
      subClass: "Roles::schema",
      error: result.error);
    }
  }
}