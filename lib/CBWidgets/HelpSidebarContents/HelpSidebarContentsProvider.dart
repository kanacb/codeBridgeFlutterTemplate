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
import 'HelpSidebarContent.dart';
import 'HelpSidebarContentsService.dart';

class HelpSidebarContentsProvider with ChangeNotifier implements DataFetchable{
  List<HelpSidebarContent> _data = [];
  Box<HelpSidebarContent> hiveBox = Hive.box<HelpSidebarContent>('helpSidebarContentsBox');
  List<HelpSidebarContent> get data => _data;
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

  HelpSidebarContentsProvider() {
    loadHelpSidebarContentsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadHelpSidebarContentsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(HelpSidebarContent item) async {
    _isLoading = true;
    final Result result = await HelpSidebarContentsService(query: query).create(item);
    if (result.error == null) {
      HelpSidebarContent? data = result.data;
      hiveBox.put(data?.id, data!);
      loadHelpSidebarContentsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved HelpSidebarContents",
          subClass: "HelpSidebarContents::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      HelpSidebarContent? data = result.data;
      logger.i("Failed: creating HelpSidebarContents::createOneAndSave, error: ${result.error}, subClass: HelpSidebarContents::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating HelpSidebarContents",
          subClass: "HelpSidebarContents::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await HelpSidebarContentsService(query: query).fetchById(id);
    if (result.error == null) {
      HelpSidebarContent? data = result.data;
      hiveBox.put(data?.id, data!);
      loadHelpSidebarContentsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "HelpSidebarContents::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: HelpSidebarContents::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching HelpSidebarContents $id", 
        error: result.error, 
        subClass: "HelpSidebarContents::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await HelpSidebarContentsService(query: query).fetchAll();
    if (result.error == null) {
      List<HelpSidebarContent>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((HelpSidebarContent item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadHelpSidebarContentsFromHive();
      return Response(
        msg: "Success: Fetched all HelpSidebarContents",
        subClass: "HelpSidebarContents::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("HelpSidebarContents::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all HelpSidebarContents", 
        subClass: "HelpSidebarContents::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, HelpSidebarContent item) async {
    _isLoading = true;
    final Result result = await HelpSidebarContentsService().update(id, item);
    if (result.error == null) {
      HelpSidebarContent? data = result.data;
      hiveBox.put(data?.id, data!);
      loadHelpSidebarContentsFromHive();
      return Response(
        msg: "Success: Updated HelpSidebarContents ${id}", 
        subClass: "HelpSidebarContents::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("HelpSidebarContents::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating HelpSidebarContents ${id}",
        subClass: "HelpSidebarContents::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await HelpSidebarContentsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadHelpSidebarContentsFromHive();
      return Response(
          msg: "Success: deleted HelpSidebarContents $id",
          subClass: "HelpSidebarContents::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("HelpSidebarContents::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting HelpSidebarContents $id",
      data : { "id" : id.toString() },
      subClass: "HelpSidebarContents::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("HelpSidebarContentsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of HelpSidebarContents",
          subClass: "HelpSidebarContents::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: HelpSidebarContentsSchema", 
      subClass: "HelpSidebarContents::schema",
      error: result.error);
    }
  }
}