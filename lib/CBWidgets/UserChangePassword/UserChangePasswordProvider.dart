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
import 'UserChangePassword.dart';
import 'UserChangePasswordService.dart';

class UserChangePasswordProvider with ChangeNotifier implements DataFetchable{
  List<UserChangePassword> _data = [];
  Box<UserChangePassword> hiveBox = Hive.box<UserChangePassword>('userChangePasswordBox');
  List<UserChangePassword> get data => _data;
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

  UserChangePasswordProvider() {
    loadUserChangePasswordFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadUserChangePasswordFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(UserChangePassword item) async {
    _isLoading = true;
    final Result result = await UserChangePasswordService(query: query).create(item);
    if (result.error == null) {
      UserChangePassword? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserChangePasswordFromHive();
      return Response(
          data: data,
          msg: "Success: Saved UserChangePassword",
          subClass: "UserChangePassword::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      UserChangePassword? data = result.data;
      logger.i("Failed: creating UserChangePassword::createOneAndSave, error: ${result.error}, subClass: UserChangePassword::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating UserChangePassword",
          subClass: "UserChangePassword::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UserChangePasswordService(query: query).fetchById(id);
    if (result.error == null) {
      UserChangePassword? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserChangePasswordFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "UserChangePassword::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: UserChangePassword::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching UserChangePassword $id", 
        error: result.error, 
        subClass: "UserChangePassword::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UserChangePasswordService(query: query).fetchAll();
    if (result.error == null) {
      List<UserChangePassword>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((UserChangePassword item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUserChangePasswordFromHive();
      return Response(
        msg: "Success: Fetched all UserChangePassword",
        subClass: "UserChangePassword::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserChangePassword::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all UserChangePassword", 
        subClass: "UserChangePassword::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, UserChangePassword item) async {
    _isLoading = true;
    final Result result = await UserChangePasswordService().update(id, item);
    if (result.error == null) {
      UserChangePassword? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserChangePasswordFromHive();
      return Response(
        msg: "Success: Updated UserChangePassword ${id}", 
        subClass: "UserChangePassword::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserChangePassword::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating UserChangePassword ${id}",
        subClass: "UserChangePassword::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UserChangePasswordService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUserChangePasswordFromHive();
      return Response(
          msg: "Success: deleted UserChangePassword $id",
          subClass: "UserChangePassword::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("UserChangePassword::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting UserChangePassword $id",
      data : { "id" : id.toString() },
      subClass: "UserChangePassword::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UserChangePasswordSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of UserChangePassword",
          subClass: "UserChangePassword::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UserChangePasswordSchema", 
      subClass: "UserChangePassword::schema",
      error: result.error);
    }
  }
}