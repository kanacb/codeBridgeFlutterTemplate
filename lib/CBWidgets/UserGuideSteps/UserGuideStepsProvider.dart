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
import 'UserGuideStep.dart';
import 'UserGuideStepsService.dart';

class UserGuideStepsProvider with ChangeNotifier implements DataFetchable{
  List<UserGuideStep> _data = [];
  Box<UserGuideStep> hiveBox = Hive.box<UserGuideStep>('userGuideStepsBox');
  List<UserGuideStep> get data => _data;
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
      "path": "userGuideID",
      "service": "userGuide",
      "select": [
        "serviceName",
        "expiry"
      ]
    }
  ]
};

  UserGuideStepsProvider() {
    loadUserGuideStepsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadUserGuideStepsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(UserGuideStep item) async {
    _isLoading = true;
    final Result result = await UserGuideStepsService(query: query).create(item);
    if (result.error == null) {
      UserGuideStep? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserGuideStepsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved UserGuideSteps",
          subClass: "UserGuideSteps::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      UserGuideStep? data = result.data;
      logger.i("Failed: creating UserGuideSteps::createOneAndSave, error: ${result.error}, subClass: UserGuideSteps::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating UserGuideSteps",
          subClass: "UserGuideSteps::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UserGuideStepsService(query: query).fetchById(id);
    if (result.error == null) {
      UserGuideStep? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserGuideStepsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "UserGuideSteps::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: UserGuideSteps::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching UserGuideSteps $id", 
        error: result.error, 
        subClass: "UserGuideSteps::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UserGuideStepsService(query: query).fetchAll();
    if (result.error == null) {
      List<UserGuideStep>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((UserGuideStep item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUserGuideStepsFromHive();
      return Response(
        msg: "Success: Fetched all UserGuideSteps",
        subClass: "UserGuideSteps::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserGuideSteps::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all UserGuideSteps", 
        subClass: "UserGuideSteps::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, UserGuideStep item) async {
    _isLoading = true;
    final Result result = await UserGuideStepsService().update(id, item);
    if (result.error == null) {
      UserGuideStep? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserGuideStepsFromHive();
      return Response(
        msg: "Success: Updated UserGuideSteps ${id}", 
        subClass: "UserGuideSteps::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserGuideSteps::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating UserGuideSteps ${id}",
        subClass: "UserGuideSteps::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UserGuideStepsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUserGuideStepsFromHive();
      return Response(
          msg: "Success: deleted UserGuideSteps $id",
          subClass: "UserGuideSteps::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("UserGuideSteps::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting UserGuideSteps $id",
      data : { "id" : id.toString() },
      subClass: "UserGuideSteps::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UserGuideStepsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of UserGuideSteps",
          subClass: "UserGuideSteps::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UserGuideStepsSchema", 
      subClass: "UserGuideSteps::schema",
      error: result.error);
    }
  }
}