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
import 'PermissionField.dart';
import 'PermissionFieldsService.dart';

class PermissionFieldsProvider with ChangeNotifier implements DataFetchable{
  List<PermissionField> _data = [];
  Box<PermissionField> hiveBox = Hive.box<PermissionField>('permissionFieldsBox');
  List<PermissionField> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final String query;
  Map<String, dynamic> mapQuery = {
  "limit": 1000,
  "\$sort": {
    "createdAt": -1
  },
  "\$populate": [
    {
      "path": "servicePermissionId",
      "service": "permissionServices",
      "select": [
        "service",
        "create",
        "read",
        "update",
        "delete",
        "import",
        "export",
        "seeder",
        "userId",
        "roleId",
        "profile",
        "positionId"
      ]
    }
  ]
};

  PermissionFieldsProvider() {
    loadPermissionFieldsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadPermissionFieldsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(PermissionField item) async {
    _isLoading = true;
    final Result result = await PermissionFieldsService(query: query).create(item);
    if (result.error == null) {
      PermissionField? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPermissionFieldsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved PermissionFields",
          subClass: "PermissionFields::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      PermissionField? data = result.data;
      logger.i("Failed: creating PermissionFields::createOneAndSave, error: ${result.error}, subClass: PermissionFields::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating PermissionFields",
          subClass: "PermissionFields::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await PermissionFieldsService(query: query).fetchById(id);
    if (result.error == null) {
      PermissionField? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPermissionFieldsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "PermissionFields::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: PermissionFields::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching PermissionFields $id", 
        error: result.error, 
        subClass: "PermissionFields::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await PermissionFieldsService(query: query).fetchAll();
    if (result.error == null) {
      List<PermissionField>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((PermissionField item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadPermissionFieldsFromHive();
      return Response(
        msg: "Success: Fetched all PermissionFields",
        subClass: "PermissionFields::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PermissionFields::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all PermissionFields", 
        subClass: "PermissionFields::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, PermissionField item) async {
    _isLoading = true;
    final Result result = await PermissionFieldsService().update(id, item);
    if (result.error == null) {
      PermissionField? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPermissionFieldsFromHive();
      return Response(
        msg: "Success: Updated PermissionFields ${id}", 
        subClass: "PermissionFields::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PermissionFields::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating PermissionFields ${id}",
        subClass: "PermissionFields::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await PermissionFieldsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadPermissionFieldsFromHive();
      return Response(
          msg: "Success: deleted PermissionFields $id",
          subClass: "PermissionFields::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("PermissionFields::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting PermissionFields $id",
      data : { "id" : id.toString() },
      subClass: "PermissionFields::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("PermissionFieldsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of PermissionFields",
          subClass: "PermissionFields::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: PermissionFieldsSchema", 
      subClass: "PermissionFields::schema",
      error: result.error);
    }
  }
}