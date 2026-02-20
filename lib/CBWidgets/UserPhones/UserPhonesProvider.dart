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
import 'UserPhones.dart';
import 'UserPhonesService.dart';

class UserPhonesProvider with ChangeNotifier implements DataFetchable{
  List<UserPhones> _data = [];
  Box<UserPhones> hiveBox = Hive.box<UserPhones>('userPhonesBox');
  List<UserPhones> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  UserPhonesProvider() {
    loadUserPhonesFromHive();
  }

  void loadUserPhonesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(UserPhones item) async {
    _isLoading = true;
    final Result result = await UserPhonesService(query: query).create(item);
    if (result.error == null) {
      UserPhones? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserPhonesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved UserPhones",
          subClass: "UserPhones::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      UserPhones? data = result.data;
      logger.i("Failed: creating UserPhones::createOneAndSave, error: ${result.error}, subClass: UserPhones::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating UserPhones",
          subClass: "UserPhones::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UserPhonesService(query: query).fetchById(id);
    if (result.error == null) {
      UserPhones? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserPhonesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "UserPhones::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: UserPhones::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching UserPhones $id", 
        error: result.error, 
        subClass: "UserPhones::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UserPhonesService(query: query).fetchAll();
    if (result.error == null) {
      List<UserPhones>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((UserPhones item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUserPhonesFromHive();
      return Response(
        msg: "Success: Fetched all UserPhones",
        subClass: "UserPhones::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserPhones::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all UserPhones", 
        subClass: "UserPhones::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, UserPhones item) async {
    _isLoading = true;
    final Result result = await UserPhonesService().update(id, item);
    if (result.error == null) {
      UserPhones? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserPhonesFromHive();
      return Response(
        msg: "Success: Updated UserPhones ${id}", 
        subClass: "UserPhones::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserPhones::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating UserPhones ${id}",
        subClass: "UserPhones::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UserPhonesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUserPhonesFromHive();
      return Response(
          msg: "Success: deleted UserPhones $id",
          subClass: "UserPhones::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("UserPhones::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting UserPhones $id",
      data : { "id" : $id },
      subClass: "UserPhones::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UserPhonesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of UserPhones",
          subClass: "UserPhones::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UserPhonesSchema", 
      subClass: "UserPhones::schema",
      error: result.error);
    }
  }
}