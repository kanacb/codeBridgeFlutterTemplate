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
import 'ErrorLog.dart';
import 'ErrorLogsService.dart';

class ErrorLogsProvider with ChangeNotifier implements DataFetchable{
  List<ErrorLog> _data = [];
  Box<ErrorLog> hiveBox = Hive.box<ErrorLog>('errorLogsBox');
  List<ErrorLog> get data => _data;
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

  ErrorLogsProvider() {
    loadErrorLogsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadErrorLogsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(ErrorLog item) async {
    _isLoading = true;
    final Result result = await ErrorLogsService(query: query).create(item);
    if (result.error == null) {
      ErrorLog? data = result.data;
      hiveBox.put(data?.id, data!);
      loadErrorLogsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved ErrorLogs",
          subClass: "ErrorLogs::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      ErrorLog? data = result.data;
      logger.i("Failed: creating ErrorLogs::createOneAndSave, error: ${result.error}, subClass: ErrorLogs::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating ErrorLogs",
          subClass: "ErrorLogs::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ErrorLogsService(query: query).fetchById(id);
    if (result.error == null) {
      ErrorLog? data = result.data;
      hiveBox.put(data?.id, data!);
      loadErrorLogsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "ErrorLogs::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: ErrorLogs::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching ErrorLogs $id", 
        error: result.error, 
        subClass: "ErrorLogs::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ErrorLogsService(query: query).fetchAll();
    if (result.error == null) {
      List<ErrorLog>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((ErrorLog item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadErrorLogsFromHive();
      return Response(
        msg: "Success: Fetched all ErrorLogs",
        subClass: "ErrorLogs::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ErrorLogs::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all ErrorLogs", 
        subClass: "ErrorLogs::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, ErrorLog item) async {
    _isLoading = true;
    final Result result = await ErrorLogsService().update(id, item);
    if (result.error == null) {
      ErrorLog? data = result.data;
      hiveBox.put(data?.id, data!);
      loadErrorLogsFromHive();
      return Response(
        msg: "Success: Updated ErrorLogs ${id}", 
        subClass: "ErrorLogs::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ErrorLogs::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating ErrorLogs ${id}",
        subClass: "ErrorLogs::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ErrorLogsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadErrorLogsFromHive();
      return Response(
          msg: "Success: deleted ErrorLogs $id",
          subClass: "ErrorLogs::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("ErrorLogs::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting ErrorLogs $id",
      data : { "id" : id.toString() },
      subClass: "ErrorLogs::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("ErrorLogsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of ErrorLogs",
          subClass: "ErrorLogs::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: ErrorLogsSchema", 
      subClass: "ErrorLogs::schema",
      error: result.error);
    }
  }
}