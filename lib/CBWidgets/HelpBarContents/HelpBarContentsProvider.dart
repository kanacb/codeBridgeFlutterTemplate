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
import 'HelpBarContent.dart';
import 'HelpBarContentsService.dart';

class HelpBarContentsProvider with ChangeNotifier implements DataFetchable{
  List<HelpBarContent> _data = [];
  Box<HelpBarContent> hiveBox = Hive.box<HelpBarContent>('helpBarContentsBox');
  List<HelpBarContent> get data => _data;
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

  HelpBarContentsProvider() {
    loadHelpBarContentsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadHelpBarContentsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(HelpBarContent item) async {
    _isLoading = true;
    final Result result = await HelpBarContentsService(query: query).create(item);
    if (result.error == null) {
      HelpBarContent? data = result.data;
      hiveBox.put(data?.id, data!);
      loadHelpBarContentsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved HelpBarContents",
          subClass: "HelpBarContents::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      HelpBarContent? data = result.data;
      logger.i("Failed: creating HelpBarContents::createOneAndSave, error: ${result.error}, subClass: HelpBarContents::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating HelpBarContents",
          subClass: "HelpBarContents::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await HelpBarContentsService(query: query).fetchById(id);
    if (result.error == null) {
      HelpBarContent? data = result.data;
      hiveBox.put(data?.id, data!);
      loadHelpBarContentsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "HelpBarContents::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: HelpBarContents::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching HelpBarContents $id", 
        error: result.error, 
        subClass: "HelpBarContents::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await HelpBarContentsService(query: query).fetchAll();
    if (result.error == null) {
      List<HelpBarContent>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((HelpBarContent item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadHelpBarContentsFromHive();
      return Response(
        msg: "Success: Fetched all HelpBarContents",
        subClass: "HelpBarContents::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("HelpBarContents::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all HelpBarContents", 
        subClass: "HelpBarContents::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, HelpBarContent item) async {
    _isLoading = true;
    final Result result = await HelpBarContentsService().update(id, item);
    if (result.error == null) {
      HelpBarContent? data = result.data;
      hiveBox.put(data?.id, data!);
      loadHelpBarContentsFromHive();
      return Response(
        msg: "Success: Updated HelpBarContents ${id}", 
        subClass: "HelpBarContents::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("HelpBarContents::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating HelpBarContents ${id}",
        subClass: "HelpBarContents::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await HelpBarContentsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadHelpBarContentsFromHive();
      return Response(
          msg: "Success: deleted HelpBarContents $id",
          subClass: "HelpBarContents::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("HelpBarContents::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting HelpBarContents $id",
      data : { "id" : id.toString() },
      subClass: "HelpBarContents::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("HelpBarContentsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of HelpBarContents",
          subClass: "HelpBarContents::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: HelpBarContentsSchema", 
      subClass: "HelpBarContents::schema",
      error: result.error);
    }
  }
}