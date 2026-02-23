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
import 'UserTrackerId.dart';
import 'UserTrackerIdService.dart';

class UserTrackerIdProvider with ChangeNotifier implements DataFetchable{
  List<UserTrackerId> _data = [];
  Box<UserTrackerId> hiveBox = Hive.box<UserTrackerId>('userTrackerIdBox');
  List<UserTrackerId> get data => _data;
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
      "path": "userId",
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

  UserTrackerIdProvider() {
    loadUserTrackerIdFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadUserTrackerIdFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(UserTrackerId item) async {
    _isLoading = true;
    final Result result = await UserTrackerIdService(query: query).create(item);
    if (result.error == null) {
      UserTrackerId? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserTrackerIdFromHive();
      return Response(
          data: data,
          msg: "Success: Saved UserTrackerId",
          subClass: "UserTrackerId::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      UserTrackerId? data = result.data;
      logger.i("Failed: creating UserTrackerId::createOneAndSave, error: ${result.error}, subClass: UserTrackerId::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating UserTrackerId",
          subClass: "UserTrackerId::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UserTrackerIdService(query: query).fetchById(id);
    if (result.error == null) {
      UserTrackerId? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserTrackerIdFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "UserTrackerId::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: UserTrackerId::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching UserTrackerId $id", 
        error: result.error, 
        subClass: "UserTrackerId::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UserTrackerIdService(query: query).fetchAll();
    if (result.error == null) {
      List<UserTrackerId>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((UserTrackerId item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUserTrackerIdFromHive();
      return Response(
        msg: "Success: Fetched all UserTrackerId",
        subClass: "UserTrackerId::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserTrackerId::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all UserTrackerId", 
        subClass: "UserTrackerId::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, UserTrackerId item) async {
    _isLoading = true;
    final Result result = await UserTrackerIdService().update(id, item);
    if (result.error == null) {
      UserTrackerId? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserTrackerIdFromHive();
      return Response(
        msg: "Success: Updated UserTrackerId ${id}", 
        subClass: "UserTrackerId::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserTrackerId::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating UserTrackerId ${id}",
        subClass: "UserTrackerId::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UserTrackerIdService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUserTrackerIdFromHive();
      return Response(
          msg: "Success: deleted UserTrackerId $id",
          subClass: "UserTrackerId::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("UserTrackerId::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting UserTrackerId $id",
      data : { "id" : id.toString() },
      subClass: "UserTrackerId::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UserTrackerIdSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of UserTrackerId",
          subClass: "UserTrackerId::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UserTrackerIdSchema", 
      subClass: "UserTrackerId::schema",
      error: result.error);
    }
  }
}