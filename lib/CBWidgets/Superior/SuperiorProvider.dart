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
import 'Superior.dart';
import 'SuperiorService.dart';

class SuperiorProvider with ChangeNotifier implements DataFetchable{
  List<Superior> _data = [];
  Box<Superior> hiveBox = Hive.box<Superior>('superiorBox');
  List<Superior> get data => _data;
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
      "path": "superior",
      "service": "staffinfo",
      "select": [
        "empno",
        "name",
        "namenric",
        "compcode",
        "compname",
        "deptcode",
        "deptdesc",
        "sectcode",
        "sectdesc",
        "designation",
        "email",
        "resign",
        "supervisor",
        "datejoin",
        "empgroup",
        "empgradecode",
        "terminationdate"
      ]
    },
    {
      "path": "subordinate",
      "service": "staffinfo",
      "select": [
        "empno",
        "name",
        "namenric",
        "compcode",
        "compname",
        "deptcode",
        "deptdesc",
        "sectcode",
        "sectdesc",
        "designation",
        "email",
        "resign",
        "supervisor",
        "datejoin",
        "empgroup",
        "empgradecode",
        "terminationdate"
      ]
    }
  ]
};

  SuperiorProvider() {
    loadSuperiorFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadSuperiorFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Superior item) async {
    _isLoading = true;
    final Result result = await SuperiorService(query: query).create(item);
    if (result.error == null) {
      Superior? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSuperiorFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Superior",
          subClass: "Superior::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Superior? data = result.data;
      logger.i("Failed: creating Superior::createOneAndSave, error: ${result.error}, subClass: Superior::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Superior",
          subClass: "Superior::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await SuperiorService(query: query).fetchById(id);
    if (result.error == null) {
      Superior? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSuperiorFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Superior::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Superior::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Superior $id", 
        error: result.error, 
        subClass: "Superior::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await SuperiorService(query: query).fetchAll();
    if (result.error == null) {
      List<Superior>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Superior item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadSuperiorFromHive();
      return Response(
        msg: "Success: Fetched all Superior",
        subClass: "Superior::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Superior::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Superior", 
        subClass: "Superior::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Superior item) async {
    _isLoading = true;
    final Result result = await SuperiorService().update(id, item);
    if (result.error == null) {
      Superior? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSuperiorFromHive();
      return Response(
        msg: "Success: Updated Superior ${id}", 
        subClass: "Superior::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Superior::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Superior ${id}",
        subClass: "Superior::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await SuperiorService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadSuperiorFromHive();
      return Response(
          msg: "Success: deleted Superior $id",
          subClass: "Superior::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Superior::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Superior $id",
      data : { "id" : id.toString() },
      subClass: "Superior::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("SuperiorSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Superior",
          subClass: "Superior::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: SuperiorSchema", 
      subClass: "Superior::schema",
      error: result.error);
    }
  }
}