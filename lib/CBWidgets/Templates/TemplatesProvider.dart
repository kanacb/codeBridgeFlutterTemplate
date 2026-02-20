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
import 'Template.dart';
import 'TemplatesService.dart';

class TemplatesProvider with ChangeNotifier implements DataFetchable{
  List<Template> _data = [];
  Box<Template> hiveBox = Hive.box<Template>('templatesBox');
  List<Template> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  TemplatesProvider() {
    loadTemplatesFromHive();
  }

  void loadTemplatesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Template item) async {
    _isLoading = true;
    final Result result = await TemplatesService(query: query).create(item);
    if (result.error == null) {
      Template? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTemplatesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Templates",
          subClass: "Templates::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Template? data = result.data;
      logger.i("Failed: creating Templates::createOneAndSave, error: ${result.error}, subClass: Templates::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Templates",
          subClass: "Templates::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await TemplatesService(query: query).fetchById(id);
    if (result.error == null) {
      Template? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTemplatesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Templates::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Templates::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Templates $id", 
        error: result.error, 
        subClass: "Templates::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await TemplatesService(query: query).fetchAll();
    if (result.error == null) {
      List<Template>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Template item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadTemplatesFromHive();
      return Response(
        msg: "Success: Fetched all Templates",
        subClass: "Templates::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Templates::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Templates", 
        subClass: "Templates::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Template item) async {
    _isLoading = true;
    final Result result = await TemplatesService().update(id, item);
    if (result.error == null) {
      Template? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTemplatesFromHive();
      return Response(
        msg: "Success: Updated Templates ${id}", 
        subClass: "Templates::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Templates::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Templates ${id}",
        subClass: "Templates::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await TemplatesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadTemplatesFromHive();
      return Response(
          msg: "Success: deleted Templates $id",
          subClass: "Templates::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Templates::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Templates $id",
      data : { "id" : id.toString() },
      subClass: "Templates::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("TemplatesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Templates",
          subClass: "Templates::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: TemplatesSchema", 
      subClass: "Templates::schema",
      error: result.error);
    }
  }
}