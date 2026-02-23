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
import 'PermissionService.dart';
import 'PermissionServicesService.dart';

class PermissionServicesProvider with ChangeNotifier implements DataFetchable{
  List<PermissionService> _data = [];
  Box<PermissionService> hiveBox = Hive.box<PermissionService>('permissionServicesBox');
  List<PermissionService> get data => _data;
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
      "path": "userId",
      "service": "users",
      "select": [
        "name",
        "email",
        "password",
        "status"
      ]
    },
    {
      "path": "roleId",
      "service": "roles",
      "select": [
        "name",
        "description",
        "isDefault"
      ]
    },
    {
      "path": "profile",
      "service": "profiles",
      "select": [
        "name",
        "userId",
        "image",
        "bio",
        "department",
        "hod",
        "section",
        "hos",
        "role",
        "position",
        "manager",
        "company",
        "branch",
        "skills",
        "address",
        "phone"
      ]
    },
    {
      "path": "positionId",
      "service": "positions",
      "select": [
        "roleId",
        "name",
        "description",
        "abbr",
        "isDefault"
      ]
    }
  ]
};

  PermissionServicesProvider() {
    loadPermissionServicesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadPermissionServicesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(PermissionService item) async {
    _isLoading = true;
    final Result result = await PermissionServicesService(query: query).create(item);
    if (result.error == null) {
      PermissionService? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPermissionServicesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved PermissionServices",
          subClass: "PermissionServices::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      PermissionService? data = result.data;
      logger.i("Failed: creating PermissionServices::createOneAndSave, error: ${result.error}, subClass: PermissionServices::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating PermissionServices",
          subClass: "PermissionServices::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await PermissionServicesService(query: query).fetchById(id);
    if (result.error == null) {
      PermissionService? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPermissionServicesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "PermissionServices::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: PermissionServices::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching PermissionServices $id", 
        error: result.error, 
        subClass: "PermissionServices::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await PermissionServicesService(query: query).fetchAll();
    if (result.error == null) {
      List<PermissionService>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((PermissionService item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadPermissionServicesFromHive();
      return Response(
        msg: "Success: Fetched all PermissionServices",
        subClass: "PermissionServices::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PermissionServices::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all PermissionServices", 
        subClass: "PermissionServices::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, PermissionService item) async {
    _isLoading = true;
    final Result result = await PermissionServicesService().update(id, item);
    if (result.error == null) {
      PermissionService? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPermissionServicesFromHive();
      return Response(
        msg: "Success: Updated PermissionServices ${id}", 
        subClass: "PermissionServices::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PermissionServices::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating PermissionServices ${id}",
        subClass: "PermissionServices::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await PermissionServicesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadPermissionServicesFromHive();
      return Response(
          msg: "Success: deleted PermissionServices $id",
          subClass: "PermissionServices::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("PermissionServices::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting PermissionServices $id",
      data : { "id" : id.toString() },
      subClass: "PermissionServices::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("PermissionServicesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of PermissionServices",
          subClass: "PermissionServices::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: PermissionServicesSchema", 
      subClass: "PermissionServices::schema",
      error: result.error);
    }
  }
}