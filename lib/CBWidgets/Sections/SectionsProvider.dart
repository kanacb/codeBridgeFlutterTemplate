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
import 'Sections.dart';
import 'SectionsService.dart';

class SectionsProvider with ChangeNotifier implements DataFetchable{
  List<Sections> _data = [];
  Box<Sections> hiveBox = Hive.box<Sections>('sectionsBox');
  List<Sections> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  SectionsProvider() {
    loadSectionsFromHive();
  }

  void loadSectionsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Sections item) async {
    _isLoading = true;
    final Result result = await SectionsService(query: query).create(item);
    if (result.error == null) {
      Sections? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSectionsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Sections",
          subClass: "Sections::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Sections? data = result.data;
      logger.i("Failed: creating Sections::createOneAndSave, error: ${result.error}, subClass: Sections::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Sections",
          subClass: "Sections::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await SectionsService(query: query).fetchById(id);
    if (result.error == null) {
      Sections? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSectionsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Sections::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Sections::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Sections $id", 
        error: result.error, 
        subClass: "Sections::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await SectionsService(query: query).fetchAll();
    if (result.error == null) {
      List<Sections>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Sections item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadSectionsFromHive();
      return Response(
        msg: "Success: Fetched all Sections",
        subClass: "Sections::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Sections::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Sections", 
        subClass: "Sections::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Sections item) async {
    _isLoading = true;
    final Result result = await SectionsService().update(id, item);
    if (result.error == null) {
      Sections? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSectionsFromHive();
      return Response(
        msg: "Success: Updated Sections ${id}", 
        subClass: "Sections::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Sections::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Sections ${id}",
        subClass: "Sections::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await SectionsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadSectionsFromHive();
      return Response(
          msg: "Success: deleted Sections $id",
          subClass: "Sections::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Sections::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Sections $id",
      data : { "id" : id.toString() },
      subClass: "Sections::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("SectionsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Sections",
          subClass: "Sections::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: SectionsSchema", 
      subClass: "Sections::schema",
      error: result.error);
    }
  }
}