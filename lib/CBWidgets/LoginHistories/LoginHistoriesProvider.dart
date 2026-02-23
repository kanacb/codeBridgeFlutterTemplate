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
import 'LoginHistory.dart';
import 'LoginHistoriesService.dart';

class LoginHistoriesProvider with ChangeNotifier implements DataFetchable{
  List<LoginHistory> _data = [];
  Box<LoginHistory> hiveBox = Hive.box<LoginHistory>('loginHistoriesBox');
  List<LoginHistory> get data => _data;
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
    }
  ]
};

  LoginHistoriesProvider() {
    loadLoginHistoriesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadLoginHistoriesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(LoginHistory item) async {
    _isLoading = true;
    final Result result = await LoginHistoriesService(query: query).create(item);
    if (result.error == null) {
      LoginHistory? data = result.data;
      hiveBox.put(data?.id, data!);
      loadLoginHistoriesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved LoginHistories",
          subClass: "LoginHistories::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      LoginHistory? data = result.data;
      logger.i("Failed: creating LoginHistories::createOneAndSave, error: ${result.error}, subClass: LoginHistories::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating LoginHistories",
          subClass: "LoginHistories::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await LoginHistoriesService(query: query).fetchById(id);
    if (result.error == null) {
      LoginHistory? data = result.data;
      hiveBox.put(data?.id, data!);
      loadLoginHistoriesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "LoginHistories::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: LoginHistories::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching LoginHistories $id", 
        error: result.error, 
        subClass: "LoginHistories::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await LoginHistoriesService(query: query).fetchAll();
    if (result.error == null) {
      List<LoginHistory>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((LoginHistory item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadLoginHistoriesFromHive();
      return Response(
        msg: "Success: Fetched all LoginHistories",
        subClass: "LoginHistories::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("LoginHistories::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all LoginHistories", 
        subClass: "LoginHistories::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, LoginHistory item) async {
    _isLoading = true;
    final Result result = await LoginHistoriesService().update(id, item);
    if (result.error == null) {
      LoginHistory? data = result.data;
      hiveBox.put(data?.id, data!);
      loadLoginHistoriesFromHive();
      return Response(
        msg: "Success: Updated LoginHistories ${id}", 
        subClass: "LoginHistories::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("LoginHistories::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating LoginHistories ${id}",
        subClass: "LoginHistories::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await LoginHistoriesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadLoginHistoriesFromHive();
      return Response(
          msg: "Success: deleted LoginHistories $id",
          subClass: "LoginHistories::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("LoginHistories::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting LoginHistories $id",
      data : { "id" : id.toString() },
      subClass: "LoginHistories::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("LoginHistoriesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of LoginHistories",
          subClass: "LoginHistories::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: LoginHistoriesSchema", 
      subClass: "LoginHistories::schema",
      error: result.error);
    }
  }
}