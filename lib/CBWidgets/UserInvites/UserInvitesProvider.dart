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
import 'UserInvite.dart';
import 'UserInvitesService.dart';

class UserInvitesProvider with ChangeNotifier implements DataFetchable{
  List<UserInvite> _data = [];
  Box<UserInvite> hiveBox = Hive.box<UserInvite>('userInvitesBox');
  List<UserInvite> get data => _data;
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
      "path": "position",
      "service": "positions",
      "select": [
        "roleId",
        "name",
        "description",
        "abbr",
        "isDefault"
      ]
    },
    {
      "path": "role",
      "service": "roles",
      "select": [
        "name",
        "description",
        "isDefault"
      ]
    },
    {
      "path": "company",
      "service": "companies",
      "select": [
        "name",
        "companyNo",
        "newCompanyNumber",
        "DateIncorporated",
        "isdefault"
      ]
    },
    {
      "path": "branch",
      "service": "branches",
      "select": [
        "companyId",
        "name",
        "isDefault"
      ]
    },
    {
      "path": "department",
      "service": "departments",
      "select": [
        "company",
        "deptName",
        "code",
        "isDefault"
      ]
    },
    {
      "path": "section",
      "service": "sections",
      "select": [
        "departmentId",
        "name",
        "code",
        "isDefault"
      ]
    }
  ]
};

  UserInvitesProvider() {
    loadUserInvitesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadUserInvitesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(UserInvite item) async {
    _isLoading = true;
    final Result result = await UserInvitesService(query: query).create(item);
    if (result.error == null) {
      UserInvite? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserInvitesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved UserInvites",
          subClass: "UserInvites::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      UserInvite? data = result.data;
      logger.i("Failed: creating UserInvites::createOneAndSave, error: ${result.error}, subClass: UserInvites::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating UserInvites",
          subClass: "UserInvites::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UserInvitesService(query: query).fetchById(id);
    if (result.error == null) {
      UserInvite? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserInvitesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "UserInvites::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: UserInvites::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching UserInvites $id", 
        error: result.error, 
        subClass: "UserInvites::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UserInvitesService(query: query).fetchAll();
    if (result.error == null) {
      List<UserInvite>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((UserInvite item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUserInvitesFromHive();
      return Response(
        msg: "Success: Fetched all UserInvites",
        subClass: "UserInvites::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserInvites::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all UserInvites", 
        subClass: "UserInvites::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, UserInvite item) async {
    _isLoading = true;
    final Result result = await UserInvitesService().update(id, item);
    if (result.error == null) {
      UserInvite? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserInvitesFromHive();
      return Response(
        msg: "Success: Updated UserInvites ${id}", 
        subClass: "UserInvites::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserInvites::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating UserInvites ${id}",
        subClass: "UserInvites::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UserInvitesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUserInvitesFromHive();
      return Response(
          msg: "Success: deleted UserInvites $id",
          subClass: "UserInvites::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("UserInvites::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting UserInvites $id",
      data : { "id" : id.toString() },
      subClass: "UserInvites::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UserInvitesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of UserInvites",
          subClass: "UserInvites::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UserInvitesSchema", 
      subClass: "UserInvites::schema",
      error: result.error);
    }
  }
}