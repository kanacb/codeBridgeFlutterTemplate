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
import 'MenuItem.dart';
import 'MenuItemsService.dart';

class MenuItemsProvider with ChangeNotifier implements DataFetchable{
  List<MenuItem> _data = [];
  Box<MenuItem> hiveBox = Hive.box<MenuItem>('menuItemsBox');
  List<MenuItem> get data => _data;
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
      "path": "userContext",
      "service": "profileMenu",
      "select": [
        "user",
        "roles",
        "positions",
        "profiles",
        "menuItems",
        "company",
        "branch",
        "section"
      ]
    }
  ]
};

  MenuItemsProvider() {
    loadMenuItemsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadMenuItemsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(MenuItem item) async {
    _isLoading = true;
    final Result result = await MenuItemsService(query: query).create(item);
    if (result.error == null) {
      MenuItem? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMenuItemsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved MenuItems",
          subClass: "MenuItems::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      MenuItem? data = result.data;
      logger.i("Failed: creating MenuItems::createOneAndSave, error: ${result.error}, subClass: MenuItems::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating MenuItems",
          subClass: "MenuItems::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await MenuItemsService(query: query).fetchById(id);
    if (result.error == null) {
      MenuItem? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMenuItemsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "MenuItems::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: MenuItems::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching MenuItems $id", 
        error: result.error, 
        subClass: "MenuItems::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await MenuItemsService(query: query).fetchAll();
    if (result.error == null) {
      List<MenuItem>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((MenuItem item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadMenuItemsFromHive();
      return Response(
        msg: "Success: Fetched all MenuItems",
        subClass: "MenuItems::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MenuItems::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all MenuItems", 
        subClass: "MenuItems::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, MenuItem item) async {
    _isLoading = true;
    final Result result = await MenuItemsService().update(id, item);
    if (result.error == null) {
      MenuItem? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMenuItemsFromHive();
      return Response(
        msg: "Success: Updated MenuItems ${id}", 
        subClass: "MenuItems::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MenuItems::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating MenuItems ${id}",
        subClass: "MenuItems::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await MenuItemsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadMenuItemsFromHive();
      return Response(
          msg: "Success: deleted MenuItems $id",
          subClass: "MenuItems::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("MenuItems::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting MenuItems $id",
      data : { "id" : id.toString() },
      subClass: "MenuItems::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("MenuItemsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of MenuItems",
          subClass: "MenuItems::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: MenuItemsSchema", 
      subClass: "MenuItems::schema",
      error: result.error);
    }
  }
}