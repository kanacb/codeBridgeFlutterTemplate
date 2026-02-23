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
import 'ChataiPrompt.dart';
import 'ChataiPromptsService.dart';

class ChataiPromptsProvider with ChangeNotifier implements DataFetchable{
  List<ChataiPrompt> _data = [];
  Box<ChataiPrompt> hiveBox = Hive.box<ChataiPrompt>('chataiPromptsBox');
  List<ChataiPrompt> get data => _data;
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
    },
    {
      "path": "chatAiConfig",
      "service": "chataiConfig",
      "select": [
        "name",
        "chatAiEnabler",
        "bedrockModelId",
        "modelParamsJson",
        "human",
        "task",
        "noCondition",
        "yesCondition",
        "documents",
        "example",
        "preamble"
      ]
    }
  ]
};

  ChataiPromptsProvider() {
    loadChataiPromptsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadChataiPromptsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(ChataiPrompt item) async {
    _isLoading = true;
    final Result result = await ChataiPromptsService(query: query).create(item);
    if (result.error == null) {
      ChataiPrompt? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiPromptsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved ChataiPrompts",
          subClass: "ChataiPrompts::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      ChataiPrompt? data = result.data;
      logger.i("Failed: creating ChataiPrompts::createOneAndSave, error: ${result.error}, subClass: ChataiPrompts::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating ChataiPrompts",
          subClass: "ChataiPrompts::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ChataiPromptsService(query: query).fetchById(id);
    if (result.error == null) {
      ChataiPrompt? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiPromptsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "ChataiPrompts::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: ChataiPrompts::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching ChataiPrompts $id", 
        error: result.error, 
        subClass: "ChataiPrompts::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ChataiPromptsService(query: query).fetchAll();
    if (result.error == null) {
      List<ChataiPrompt>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((ChataiPrompt item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadChataiPromptsFromHive();
      return Response(
        msg: "Success: Fetched all ChataiPrompts",
        subClass: "ChataiPrompts::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ChataiPrompts::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all ChataiPrompts", 
        subClass: "ChataiPrompts::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, ChataiPrompt item) async {
    _isLoading = true;
    final Result result = await ChataiPromptsService().update(id, item);
    if (result.error == null) {
      ChataiPrompt? data = result.data;
      hiveBox.put(data?.id, data!);
      loadChataiPromptsFromHive();
      return Response(
        msg: "Success: Updated ChataiPrompts ${id}", 
        subClass: "ChataiPrompts::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("ChataiPrompts::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating ChataiPrompts ${id}",
        subClass: "ChataiPrompts::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ChataiPromptsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadChataiPromptsFromHive();
      return Response(
          msg: "Success: deleted ChataiPrompts $id",
          subClass: "ChataiPrompts::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("ChataiPrompts::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting ChataiPrompts $id",
      data : { "id" : id.toString() },
      subClass: "ChataiPrompts::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("ChataiPromptsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of ChataiPrompts",
          subClass: "ChataiPrompts::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: ChataiPromptsSchema", 
      subClass: "ChataiPrompts::schema",
      error: result.error);
    }
  }
}