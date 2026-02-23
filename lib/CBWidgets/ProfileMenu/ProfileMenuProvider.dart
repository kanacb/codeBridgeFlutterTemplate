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
import 'ProfileMenu.dart';
import 'ProfileMenuService.dart';

class ProfileMenuProvider with ChangeNotifier implements DataFetchable{
  List<ProfileMenu> _data = [];
  Box<ProfileMenu> hiveBox = Hive.box<ProfileMenu>('profileMenuBox');
  List<ProfileMenu> get data => _data;
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
      "path": "user",
      "service": "users",
      "select": [
        "name",
        "email",
        "password",
        "status"
      ]
    },
    {
      "path": "roles",
      "service": "roles",
      "select": [
        "name",
        "description",
        "isDefault"
      ]
    },
    {
      "path": "positions",
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
      "path": "profiles",
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

  ProfileMenuProvider() {
    loadProfileMenuFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadProfileMenuFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(ProfileMenu item) async {
    _isLoading = true;
    final Result result = await ProfileMenuService(query: query).create(item);
    if (result.error == null) {
      ProfileMenu? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProfileMenuFromHive();
      return Response(
          data: data,
          msg: "Success: Saved ProfileMenu",
          subClass: "ProfileMenu::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      ProfileMenu? data = result.data;
      logger.i("Failed: creating ProfileMenu::createOneAndSave, error: ${result.error}, subClass: ProfileMenu::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating ProfileMenu",
          subClass: "ProfileMenu::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ProfileMenuService(query: query).fetchById(id);
    if (result.error == null) {
      ProfileMenu? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProfileMenuFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "ProfileMenu::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: ProfileMenu::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching ProfileMenu $id", 
        error: result.error, 
        subClass: "ProfileMenu::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ProfileMenuService(query: query).fetchAll();
    if (result.error == null) {
      List<ProfileMenu>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((ProfileMenu item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadProfileMenuFromHive();
      return Response(
        msg: "Success: Fetched all ProfileMenu",
        subClass: "ProfileMenu::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ProfileMenu::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all ProfileMenu", 
        subClass: "ProfileMenu::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, ProfileMenu item) async {
    _isLoading = true;
    final Result result = await ProfileMenuService().update(id, item);
    if (result.error == null) {
      ProfileMenu? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProfileMenuFromHive();
      return Response(
        msg: "Success: Updated ProfileMenu ${id}", 
        subClass: "ProfileMenu::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ProfileMenu::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating ProfileMenu ${id}",
        subClass: "ProfileMenu::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ProfileMenuService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadProfileMenuFromHive();
      return Response(
          msg: "Success: deleted ProfileMenu $id",
          subClass: "ProfileMenu::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("ProfileMenu::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting ProfileMenu $id",
      data : { "id" : id.toString() },
      subClass: "ProfileMenu::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("ProfileMenuSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of ProfileMenu",
          subClass: "ProfileMenu::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: ProfileMenuSchema", 
      subClass: "ProfileMenu::schema",
      error: result.error);
    }
  }
}