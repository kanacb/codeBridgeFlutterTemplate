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
import 'Fcm.dart';
import 'FcmsService.dart';

class FcmsProvider with ChangeNotifier implements DataFetchable{
  List<Fcm> _data = [];
  Box<Fcm> hiveBox = Hive.box<Fcm>('fcmsBox');
  List<Fcm> get data => _data;
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

  FcmsProvider() {
    loadFcmsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadFcmsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Fcm item) async {
    _isLoading = true;
    final Result result = await FcmsService(query: query).create(item);
    if (result.error == null) {
      Fcm? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Fcms",
          subClass: "Fcms::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Fcm? data = result.data;
      logger.i("Failed: creating Fcms::createOneAndSave, error: ${result.error}, subClass: Fcms::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Fcms",
          subClass: "Fcms::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await FcmsService(query: query).fetchById(id);
    if (result.error == null) {
      Fcm? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Fcms::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Fcms::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Fcms $id", 
        error: result.error, 
        subClass: "Fcms::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await FcmsService(query: query).fetchAll();
    if (result.error == null) {
      List<Fcm>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Fcm item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadFcmsFromHive();
      return Response(
        msg: "Success: Fetched all Fcms",
        subClass: "Fcms::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Fcms::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Fcms", 
        subClass: "Fcms::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Fcm item) async {
    _isLoading = true;
    final Result result = await FcmsService().update(id, item);
    if (result.error == null) {
      Fcm? data = result.data;
      hiveBox.put(data?.id, data!);
      loadFcmsFromHive();
      return Response(
        msg: "Success: Updated Fcms ${id}", 
        subClass: "Fcms::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Fcms::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Fcms ${id}",
        subClass: "Fcms::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await FcmsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadFcmsFromHive();
      return Response(
          msg: "Success: deleted Fcms $id",
          subClass: "Fcms::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Fcms::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Fcms $id",
      data : { "id" : id.toString() },
      subClass: "Fcms::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("FcmsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Fcms",
          subClass: "Fcms::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: FcmsSchema", 
      subClass: "Fcms::schema",
      error: result.error);
    }
  }
}