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
import 'UserGuide.dart';
import 'UserGuideService.dart';

class UserGuideProvider with ChangeNotifier implements DataFetchable{
  List<UserGuide> _data = [];
  Box<UserGuide> hiveBox = Hive.box<UserGuide>('userGuideBox');
  List<UserGuide> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  UserGuideProvider() {
    loadUserGuideFromHive();
  }

  void loadUserGuideFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(UserGuide item) async {
    _isLoading = true;
    final Result result = await UserGuideService(query: query).create(item);
    if (result.error == null) {
      UserGuide? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserGuideFromHive();
      return Response(
          data: data,
          msg: "Success: Saved UserGuide",
          subClass: "UserGuide::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      UserGuide? data = result.data;
      logger.i("Failed: creating UserGuide::createOneAndSave, error: ${result.error}, subClass: UserGuide::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating UserGuide",
          subClass: "UserGuide::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UserGuideService(query: query).fetchById(id);
    if (result.error == null) {
      UserGuide? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserGuideFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "UserGuide::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: UserGuide::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching UserGuide $id", 
        error: result.error, 
        subClass: "UserGuide::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UserGuideService(query: query).fetchAll();
    if (result.error == null) {
      List<UserGuide>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((UserGuide item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUserGuideFromHive();
      return Response(
        msg: "Success: Fetched all UserGuide",
        subClass: "UserGuide::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserGuide::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all UserGuide", 
        subClass: "UserGuide::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, UserGuide item) async {
    _isLoading = true;
    final Result result = await UserGuideService().update(id, item);
    if (result.error == null) {
      UserGuide? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserGuideFromHive();
      return Response(
        msg: "Success: Updated UserGuide ${id}", 
        subClass: "UserGuide::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserGuide::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating UserGuide ${id}",
        subClass: "UserGuide::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UserGuideService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUserGuideFromHive();
      return Response(
          msg: "Success: deleted UserGuide $id",
          subClass: "UserGuide::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("UserGuide::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting UserGuide $id",
      data : { "id" : id.toString() },
      subClass: "UserGuide::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UserGuideSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of UserGuide",
          subClass: "UserGuide::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UserGuideSchema", 
      subClass: "UserGuide::schema",
      error: result.error);
    }
  }
}