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
import 'ChataiEnabler.dart';
import 'ChataiEnablerService.dart';

class ChataiEnablerProvider with ChangeNotifier implements DataFetchable{
  List<ChataiEnabler> _data = [];
  Box<ChataiEnabler> hiveBox = Hive.box<ChataiEnabler>('chataiEnablerBox');
  List<ChataiEnabler> get data => _data;
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

  ChataiEnablerProvider() {
    loadChataiEnablerFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadChataiEnablerFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(ChataiEnabler item) async {
    _isLoading = true;
    final Result result = await ChataiEnablerService(query: query).create(item);
    if (result.error == null) {
      ChataiEnabler? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiEnablerFromHive();
      return Response(
          data: data,
          msg: "Success: Saved ChataiEnabler",
          subClass: "ChataiEnabler::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      ChataiEnabler? data = result.data;
      logger.i("Failed: creating ChataiEnabler::createOneAndSave, error: ${result.error}, subClass: ChataiEnabler::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating ChataiEnabler",
          subClass: "ChataiEnabler::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ChataiEnablerService(query: query).fetchById(id);
    if (result.error == null) {
      ChataiEnabler? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiEnablerFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "ChataiEnabler::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: ChataiEnabler::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching ChataiEnabler $id", 
        error: result.error, 
        subClass: "ChataiEnabler::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ChataiEnablerService(query: query).fetchAll();
    if (result.error == null) {
      List<ChataiEnabler>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((ChataiEnabler item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadChataiEnablerFromHive();
      return Response(
        msg: "Success: Fetched all ChataiEnabler",
        subClass: "ChataiEnabler::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ChataiEnabler::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all ChataiEnabler", 
        subClass: "ChataiEnabler::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, ChataiEnabler item) async {
    _isLoading = true;
    final Result result = await ChataiEnablerService().update(id, item);
    if (result.error == null) {
      ChataiEnabler? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiEnablerFromHive();
      return Response(
        msg: "Success: Updated ChataiEnabler ${id}", 
        subClass: "ChataiEnabler::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ChataiEnabler::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating ChataiEnabler ${id}",
        subClass: "ChataiEnabler::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ChataiEnablerService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadChataiEnablerFromHive();
      return Response(
          msg: "Success: deleted ChataiEnabler $id",
          subClass: "ChataiEnabler::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("ChataiEnabler::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting ChataiEnabler $id",
      data : { "id" : id.toString() },
      subClass: "ChataiEnabler::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("ChataiEnablerSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of ChataiEnabler",
          subClass: "ChataiEnabler::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: ChataiEnablerSchema", 
      subClass: "ChataiEnabler::schema",
      error: result.error);
    }
  }
}