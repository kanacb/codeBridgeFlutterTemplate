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
import 'Step.dart';
import 'StepsService.dart';

class StepsProvider with ChangeNotifier implements DataFetchable{
  List<Step> _data = [];
  Box<Step> hiveBox = Hive.box<Step>('stepsBox');
  List<Step> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  StepsProvider() {
    loadStepsFromHive();
  }

  void loadStepsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Step item) async {
    _isLoading = true;
    final Result result = await StepsService(query: query).create(item);
    if (result.error == null) {
      Step? data = result.data;
      hiveBox.put(data?.id, data!);
      loadStepsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Steps",
          subClass: "Steps::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Step? data = result.data;
      logger.i("Failed: creating Steps::createOneAndSave, error: ${result.error}, subClass: Steps::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Steps",
          subClass: "Steps::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await StepsService(query: query).fetchById(id);
    if (result.error == null) {
      Step? data = result.data;
      hiveBox.put(data?.id, data!);
      loadStepsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Steps::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Steps::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Steps $id", 
        error: result.error, 
        subClass: "Steps::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await StepsService(query: query).fetchAll();
    if (result.error == null) {
      List<Step>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Step item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadStepsFromHive();
      return Response(
        msg: "Success: Fetched all Steps",
        subClass: "Steps::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Steps::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Steps", 
        subClass: "Steps::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Step item) async {
    _isLoading = true;
    final Result result = await StepsService().update(id, item);
    if (result.error == null) {
      Step? data = result.data;
      hiveBox.put(data?.id, data!);
      loadStepsFromHive();
      return Response(
        msg: "Success: Updated Steps ${id}", 
        subClass: "Steps::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Steps::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Steps ${id}",
        subClass: "Steps::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await StepsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadStepsFromHive();
      return Response(
          msg: "Success: deleted Steps $id",
          subClass: "Steps::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Steps::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Steps $id",
      data : { "id" : id.toString() },
      subClass: "Steps::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("StepsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Steps",
          subClass: "Steps::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: StepsSchema", 
      subClass: "Steps::schema",
      error: result.error);
    }
  }
}