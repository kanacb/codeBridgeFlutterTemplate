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
import 'Users.dart';
import 'UsersService.dart';

class UsersProvider with ChangeNotifier implements DataFetchable{
  List<Users> _data = [];
  Box<Users> hiveBox = Hive.box<Users>('usersBox');
  List<Users> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  UsersProvider() {
    loadUsersFromHive();
  }

  void loadUsersFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Users item) async {
    _isLoading = true;
    final Result result = await UsersService(query: query).create(item);
    if (result.error == null) {
      Users? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUsersFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Users",
          subClass: "Users::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Users? data = result.data;
      logger.i("Failed: creating Users::createOneAndSave, error: ${result.error}, subClass: Users::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Users",
          subClass: "Users::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UsersService(query: query).fetchById(id);
    if (result.error == null) {
      Users? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUsersFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Users::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Users::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Users $id", 
        error: result.error, 
        subClass: "Users::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UsersService(query: query).fetchAll();
    if (result.error == null) {
      List<Users>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Users item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUsersFromHive();
      return Response(
        msg: "Success: Fetched all Users",
        subClass: "Users::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Users::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Users", 
        subClass: "Users::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Users item) async {
    _isLoading = true;
    final Result result = await UsersService().update(id, item);
    if (result.error == null) {
      Users? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUsersFromHive();
      return Response(
        msg: "Success: Updated Users ${id}", 
        subClass: "Users::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Users::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Users ${id}",
        subClass: "Users::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UsersService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUsersFromHive();
      return Response(
          msg: "Success: deleted Users $id",
          subClass: "Users::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Users::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Users $id",
      data : { "id" : id.toString() },
      subClass: "Users::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UsersSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Users",
          subClass: "Users::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UsersSchema", 
      subClass: "Users::schema",
      error: result.error);
    }
  }
}