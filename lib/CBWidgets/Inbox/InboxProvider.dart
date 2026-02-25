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
import 'Inbox.dart';
import 'InboxService.dart';

class InboxProvider with ChangeNotifier implements DataFetchable{
  List<Inbox> _data = [];
  Box<Inbox> hiveBox = Hive.box<Inbox>('inboxBox');
  List<Inbox> get data => _data;
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
      "path": "from",
      "service": "users",
      "select": [
        "name",
        "email",
        "password",
        "status"
      ]
    },
    {
      "path": "toUser",
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

  InboxProvider() {
    loadInboxFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadInboxFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Inbox item) async {
    _isLoading = true;
    final Result result = await InboxService(query: query).create(item);
    if (result.error == null) {
      Inbox? data = result.data;
      hiveBox.put(data?.id, data!);
      loadInboxFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Inbox",
          subClass: "Inbox::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Inbox? data = result.data;
      logger.i("Failed: creating Inbox::createOneAndSave, error: ${result.error}, subClass: Inbox::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Inbox",
          subClass: "Inbox::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await InboxService(query: query).fetchById(id);
    if (result.error == null) {
      Inbox? data = result.data;
      hiveBox.put(data?.id, data!);
      loadInboxFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Inbox::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Inbox::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Inbox $id", 
        error: result.error, 
        subClass: "Inbox::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await InboxService(query: query).fetchAll();
    if (result.error == null) {
      List<Inbox>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Inbox item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadInboxFromHive();
      return Response(
        msg: "Success: Fetched all Inbox",
        subClass: "Inbox::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Inbox::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Inbox", 
        subClass: "Inbox::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Inbox item) async {
    _isLoading = true;
    final Result result = await InboxService().update(id, item);
    if (result.error == null) {
      Inbox? data = result.data;
      hiveBox.put(data?.id, data!);
      loadInboxFromHive();
      return Response(
        msg: "Success: Updated Inbox ${id}", 
        subClass: "Inbox::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Inbox::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Inbox ${id}",
        subClass: "Inbox::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await InboxService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadInboxFromHive();
      return Response(
          msg: "Success: deleted Inbox $id",
          subClass: "Inbox::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Inbox::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Inbox $id",
      data : { "id" : id.toString() },
      subClass: "Inbox::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("InboxSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Inbox",
          subClass: "Inbox::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: InboxSchema", 
      subClass: "Inbox::schema",
      error: result.error);
    }
  }
}