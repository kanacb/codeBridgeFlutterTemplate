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
import 'FcmMessage.dart';
import 'FcmMessagesService.dart';

class FcmMessagesProvider with ChangeNotifier implements DataFetchable{
  List<FcmMessage> _data = [];
  Box<FcmMessage> hiveBox = Hive.box<FcmMessage>('fcmMessagesBox');
  List<FcmMessage> get data => _data;
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
      "path": "recipients",
      "service": "users",
      "select": [
        "name",
        "email",
        "password",
        "status"
      ]
    }
  ]
};

  FcmMessagesProvider() {
    loadFcmMessagesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadFcmMessagesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(FcmMessage item) async {
    _isLoading = true;
    final Result result = await FcmMessagesService(query: query).create(item);
    if (result.error == null) {
      FcmMessage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmMessagesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved FcmMessages",
          subClass: "FcmMessages::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      FcmMessage? data = result.data;
      logger.i("Failed: creating FcmMessages::createOneAndSave, error: ${result.error}, subClass: FcmMessages::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating FcmMessages",
          subClass: "FcmMessages::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await FcmMessagesService(query: query).fetchById(id);
    if (result.error == null) {
      FcmMessage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmMessagesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "FcmMessages::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: FcmMessages::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching FcmMessages $id", 
        error: result.error, 
        subClass: "FcmMessages::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await FcmMessagesService(query: query).fetchAll();
    if (result.error == null) {
      List<FcmMessage>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((FcmMessage item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadFcmMessagesFromHive();
      return Response(
        msg: "Success: Fetched all FcmMessages",
        subClass: "FcmMessages::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("FcmMessages::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all FcmMessages", 
        subClass: "FcmMessages::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, FcmMessage item) async {
    _isLoading = true;
    final Result result = await FcmMessagesService().update(id, item);
    if (result.error == null) {
      FcmMessage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmMessagesFromHive();
      return Response(
        msg: "Success: Updated FcmMessages ${id}", 
        subClass: "FcmMessages::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("FcmMessages::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating FcmMessages ${id}",
        subClass: "FcmMessages::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await FcmMessagesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadFcmMessagesFromHive();
      return Response(
          msg: "Success: deleted FcmMessages $id",
          subClass: "FcmMessages::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("FcmMessages::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting FcmMessages $id",
      data : { "id" : id.toString() },
      subClass: "FcmMessages::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("FcmMessagesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of FcmMessages",
          subClass: "FcmMessages::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: FcmMessagesSchema", 
      subClass: "FcmMessages::schema",
      error: result.error);
    }
  }
}