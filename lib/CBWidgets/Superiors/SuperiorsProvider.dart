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
import 'SuperiorsService.dart';

class SuperiorsProvider with ChangeNotifier implements DataFetchable{
  List<Superior> _data = [];
  Box<Superior> hiveBox = Hive.box<Superior>('superiorsBox');
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
        "empNo",
        "name",
        "nameNric",
        "compCode",
        "compName",
        "deptCode",
        "deptDesc",
        "sectCode",
        "sectDesc",
        "designation",
        "email",
        "resign",
        "supervisor",
        "dateJoin",
        "empGroup",
        "empGradeCode",
        "terminationDate"
      ]
    },
    {
      "path": "subordinate",
      "service": "staffinfo",
      "select": [
        "empNo",
        "name",
        "nameNric",
        "compCode",
        "compName",
        "deptCode",
        "deptDesc",
        "sectCode",
        "sectDesc",
        "designation",
        "email",
        "resign",
        "supervisor",
        "dateJoin",
        "empGroup",
        "empGradeCode",
        "terminationDate"
      ]
    }
  ]
};

  SuperiorsProvider() {
    loadSuperiorsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadSuperiorsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Superior item) async {
    _isLoading = true;
    final Result result = await SuperiorsService(query: query).create(item);
    if (result.error == null) {
      Superior? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSuperiorsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Superiors",
          subClass: "Superiors::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Superior? data = result.data;
      logger.i("Failed: creating Superiors::createOneAndSave, error: ${result.error}, subClass: Superiors::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Superiors",
          subClass: "Superiors::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await SuperiorsService(query: query).fetchById(id);
    if (result.error == null) {
      Superior? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSuperiorsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Superiors::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Superiors::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Superiors $id", 
        error: result.error, 
        subClass: "Superiors::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await SuperiorsService(query: query).fetchAll();
    if (result.error == null) {
      List<Superior>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Superior item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadSuperiorsFromHive();
      return Response(
        msg: "Success: Fetched all Superiors",
        subClass: "Superiors::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Superiors::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Superiors", 
        subClass: "Superiors::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Superior item) async {
    _isLoading = true;
    final Result result = await SuperiorsService().update(id, item);
    if (result.error == null) {
      Superior? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSuperiorsFromHive();
      return Response(
        msg: "Success: Updated Superiors ${id}", 
        subClass: "Superiors::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Superiors::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Superiors ${id}",
        subClass: "Superiors::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await SuperiorsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadSuperiorsFromHive();
      return Response(
          msg: "Success: deleted Superiors $id",
          subClass: "Superiors::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Superiors::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Superiors $id",
      data : { "id" : id.toString() },
      subClass: "Superiors::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("SuperiorsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Superiors",
          subClass: "Superiors::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: SuperiorsSchema", 
      subClass: "Superiors::schema",
      error: result.error);
    }
  }
}