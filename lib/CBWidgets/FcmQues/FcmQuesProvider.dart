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
import 'FcmQue.dart';
import 'FcmQuesService.dart';

class FcmQuesProvider with ChangeNotifier implements DataFetchable{
  List<FcmQue> _data = [];
  Box<FcmQue> hiveBox = Hive.box<FcmQue>('fcmQuesBox');
  List<FcmQue> get data => _data;
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

  FcmQuesProvider() {
    loadFcmQuesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadFcmQuesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(FcmQue item) async {
    _isLoading = true;
    final Result result = await FcmQuesService(query: query).create(item);
    if (result.error == null) {
      FcmQue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmQuesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved FcmQues",
          subClass: "FcmQues::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      FcmQue? data = result.data;
      logger.i("Failed: creating FcmQues::createOneAndSave, error: ${result.error}, subClass: FcmQues::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating FcmQues",
          subClass: "FcmQues::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await FcmQuesService(query: query).fetchById(id);
    if (result.error == null) {
      FcmQue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmQuesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "FcmQues::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: FcmQues::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching FcmQues $id", 
        error: result.error, 
        subClass: "FcmQues::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await FcmQuesService(query: query).fetchAll();
    if (result.error == null) {
      List<FcmQue>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((FcmQue item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadFcmQuesFromHive();
      return Response(
        msg: "Success: Fetched all FcmQues",
        subClass: "FcmQues::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("FcmQues::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all FcmQues", 
        subClass: "FcmQues::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, FcmQue item) async {
    _isLoading = true;
    final Result result = await FcmQuesService().update(id, item);
    if (result.error == null) {
      FcmQue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmQuesFromHive();
      return Response(
        msg: "Success: Updated FcmQues ${id}", 
        subClass: "FcmQues::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("FcmQues::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating FcmQues ${id}",
        subClass: "FcmQues::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await FcmQuesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadFcmQuesFromHive();
      return Response(
          msg: "Success: deleted FcmQues $id",
          subClass: "FcmQues::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("FcmQues::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting FcmQues $id",
      data : { "id" : id.toString() },
      subClass: "FcmQues::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("FcmQuesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of FcmQues",
          subClass: "FcmQues::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: FcmQuesSchema", 
      subClass: "FcmQues::schema",
      error: result.error);
    }
  }
}