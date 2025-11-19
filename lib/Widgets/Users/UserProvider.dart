import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Utils/Services/SchemaService.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'User.dart';
import 'UserService.dart';

class UserProvider with ChangeNotifier {
  List<User> _data = [];
  Box<User> hiveBox = Hive.box<User>('usersBox');
  List<User> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String query = "";

  UserProvider() {
    loadUsersFromHive();
  }

  void loadUsersFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(User item) async {
    _isLoading = true;
    final Result result = await UserService(query: query).create(item);
    if (result.error == null) {
      User? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUsersFromHive();
      return Response(
          data: data,
          msg: "Success: created user ${item.name}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("User create : ${result.error}");
      return Response(
          msg: "Failed: creating user ${item.name}", error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UserService(query: query).fetchById(id);
    if (result.error == null) {
      User? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUsersFromHive();
      return Response(
          data: data,
          msg: "Success: saved user $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("User get one : ${result.error}");
      return Response(msg: "Failed: saving user $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UserService(query: query).fetchAll();
    if (result.error == null) {
      List<User>? data = result.data;
      var isEmpty = false;
      if(_data.isEmpty) isEmpty = true;
      data?.forEach((User item) {
        hiveBox.put(item.id, item);
        if(isEmpty) _data.add(item);
      });
      loadUsersFromHive();
      return Response(
          msg: "Success: fetched all", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Users get all error: ${result.error}");
      return Response(msg: "Failed: fetch all", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, User item) async {
    _isLoading = true;
    final Result result = await UserService().update(id, item);
    if (result.error == null) {
      User? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUsersFromHive();
      return Response(
          msg: "Success: updated user $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("User update : ${result.error}");
      return Response(msg: "Failed: updating user $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UserService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUsersFromHive();
      return Response(
          msg: "Success: deleted user $id", statusCode: result.statusCode);
    } else {
      logger.i("User delete : ${result.error}");
      return Response(msg: "Failed: deleting user $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("usersSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of users",
          statusCode: result.statusCode);
    } else {
      logger.i("User schema data: ${result.data}");
      logger.i("User schema error: ${result.error}");
      return Response(msg: "Failed: usersSchema", error: result.error);
    }
  }
}
