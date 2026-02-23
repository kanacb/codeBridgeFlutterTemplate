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
import 'ChataiConfig.dart';
import 'ChataiConfigService.dart';

class ChataiConfigProvider with ChangeNotifier implements DataFetchable{
  List<ChataiConfig> _data = [];
  Box<ChataiConfig> hiveBox = Hive.box<ChataiConfig>('chataiConfigBox');
  List<ChataiConfig> get data => _data;
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
      "path": "chatAiEnabler",
      "service": "chataiEnabler",
      "select": [
        "name",
        "serviceName",
        "description"
      ]
    }
  ]
};

  ChataiConfigProvider() {
    loadChataiConfigFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadChataiConfigFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(ChataiConfig item) async {
    _isLoading = true;
    final Result result = await ChataiConfigService(query: query).create(item);
    if (result.error == null) {
      ChataiConfig? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiConfigFromHive();
      return Response(
          data: data,
          msg: "Success: Saved ChataiConfig",
          subClass: "ChataiConfig::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      ChataiConfig? data = result.data;
      logger.i("Failed: creating ChataiConfig::createOneAndSave, error: ${result.error}, subClass: ChataiConfig::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating ChataiConfig",
          subClass: "ChataiConfig::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ChataiConfigService(query: query).fetchById(id);
    if (result.error == null) {
      ChataiConfig? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiConfigFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "ChataiConfig::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: ChataiConfig::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching ChataiConfig $id", 
        error: result.error, 
        subClass: "ChataiConfig::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ChataiConfigService(query: query).fetchAll();
    if (result.error == null) {
      List<ChataiConfig>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((ChataiConfig item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadChataiConfigFromHive();
      return Response(
        msg: "Success: Fetched all ChataiConfig",
        subClass: "ChataiConfig::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ChataiConfig::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all ChataiConfig", 
        subClass: "ChataiConfig::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, ChataiConfig item) async {
    _isLoading = true;
    final Result result = await ChataiConfigService().update(id, item);
    if (result.error == null) {
      ChataiConfig? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiConfigFromHive();
      return Response(
        msg: "Success: Updated ChataiConfig ${id}", 
        subClass: "ChataiConfig::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ChataiConfig::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating ChataiConfig ${id}",
        subClass: "ChataiConfig::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ChataiConfigService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadChataiConfigFromHive();
      return Response(
          msg: "Success: deleted ChataiConfig $id",
          subClass: "ChataiConfig::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("ChataiConfig::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting ChataiConfig $id",
      data : { "id" : id.toString() },
      subClass: "ChataiConfig::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("ChataiConfigSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of ChataiConfig",
          subClass: "ChataiConfig::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: ChataiConfigSchema", 
      subClass: "ChataiConfig::schema",
      error: result.error);
    }
  }
}