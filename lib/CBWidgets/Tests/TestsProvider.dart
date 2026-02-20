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
import 'Tests.dart';
import 'TestsService.dart';

class TestsProvider with ChangeNotifier implements DataFetchable{
  List<Tests> _data = [];
  Box<Tests> hiveBox = Hive.box<Tests>('testsBox');
  List<Tests> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  TestsProvider() {
    loadTestsFromHive();
  }

  void loadTestsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Tests item) async {
    _isLoading = true;
    final Result result = await TestsService(query: query).create(item);
    if (result.error == null) {
      Tests? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTestsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Tests",
          subClass: "Tests::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Tests? data = result.data;
      logger.i("Failed: creating Tests::createOneAndSave, error: ${result.error}, subClass: Tests::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Tests",
          subClass: "Tests::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await TestsService(query: query).fetchById(id);
    if (result.error == null) {
      Tests? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTestsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Tests::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Tests::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Tests $id", 
        error: result.error, 
        subClass: "Tests::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await TestsService(query: query).fetchAll();
    if (result.error == null) {
      List<Tests>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Tests item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadTestsFromHive();
      return Response(
        msg: "Success: Fetched all Tests",
        subClass: "Tests::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Tests::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Tests", 
        subClass: "Tests::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Tests item) async {
    _isLoading = true;
    final Result result = await TestsService().update(id, item);
    if (result.error == null) {
      Tests? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTestsFromHive();
      return Response(
        msg: "Success: Updated Tests ${id}", 
        subClass: "Tests::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Tests::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Tests ${id}",
        subClass: "Tests::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await TestsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadTestsFromHive();
      return Response(
          msg: "Success: deleted Tests $id",
          subClass: "Tests::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Tests::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Tests $id",
      data : { "id" : id.toString() },
      subClass: "Tests::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("TestsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Tests",
          subClass: "Tests::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: TestsSchema", 
      subClass: "Tests::schema",
      error: result.error);
    }
  }
}