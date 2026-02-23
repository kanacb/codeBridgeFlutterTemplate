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
import 'Uploader.dart';
import 'UploaderService.dart';

class UploaderProvider with ChangeNotifier implements DataFetchable{
  List<Uploader> _data = [];
  Box<Uploader> hiveBox = Hive.box<Uploader>('uploaderBox');
  List<Uploader> get data => _data;
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
    }
  ]
};

  UploaderProvider() {
    loadUploaderFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadUploaderFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Uploader item) async {
    _isLoading = true;
    final Result result = await UploaderService(query: query).create(item);
    if (result.error == null) {
      Uploader? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUploaderFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Uploader",
          subClass: "Uploader::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Uploader? data = result.data;
      logger.i("Failed: creating Uploader::createOneAndSave, error: ${result.error}, subClass: Uploader::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Uploader",
          subClass: "Uploader::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UploaderService(query: query).fetchById(id);
    if (result.error == null) {
      Uploader? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUploaderFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Uploader::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Uploader::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Uploader $id", 
        error: result.error, 
        subClass: "Uploader::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UploaderService(query: query).fetchAll();
    if (result.error == null) {
      List<Uploader>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Uploader item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUploaderFromHive();
      return Response(
        msg: "Success: Fetched all Uploader",
        subClass: "Uploader::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Uploader::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Uploader", 
        subClass: "Uploader::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Uploader item) async {
    _isLoading = true;
    final Result result = await UploaderService().update(id, item);
    if (result.error == null) {
      Uploader? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUploaderFromHive();
      return Response(
        msg: "Success: Updated Uploader ${id}", 
        subClass: "Uploader::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Uploader::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Uploader ${id}",
        subClass: "Uploader::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UploaderService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUploaderFromHive();
      return Response(
          msg: "Success: deleted Uploader $id",
          subClass: "Uploader::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Uploader::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Uploader $id",
      data : { "id" : id.toString() },
      subClass: "Uploader::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UploaderSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Uploader",
          subClass: "Uploader::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UploaderSchema", 
      subClass: "Uploader::schema",
      error: result.error);
    }
  }
}