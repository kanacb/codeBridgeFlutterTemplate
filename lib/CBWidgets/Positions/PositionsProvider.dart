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
import 'Positions.dart';
import 'PositionsService.dart';

class PositionsProvider with ChangeNotifier implements DataFetchable{
  List<Positions> _data = [];
  Box<Positions> hiveBox = Hive.box<Positions>('positionsBox');
  List<Positions> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  PositionsProvider() {
    loadPositionsFromHive();
  }

  void loadPositionsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Positions item) async {
    _isLoading = true;
    final Result result = await PositionsService(query: query).create(item);
    if (result.error == null) {
      Positions? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPositionsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Positions",
          subClass: "Positions::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Positions? data = result.data;
      logger.i("Failed: creating Positions::createOneAndSave, error: ${result.error}, subClass: Positions::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Positions",
          subClass: "Positions::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await PositionsService(query: query).fetchById(id);
    if (result.error == null) {
      Positions? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPositionsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Positions::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Positions::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Positions $id", 
        error: result.error, 
        subClass: "Positions::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await PositionsService(query: query).fetchAll();
    if (result.error == null) {
      List<Positions>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Positions item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadPositionsFromHive();
      return Response(
        msg: "Success: Fetched all Positions",
        subClass: "Positions::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Positions::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Positions", 
        subClass: "Positions::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Positions item) async {
    _isLoading = true;
    final Result result = await PositionsService().update(id, item);
    if (result.error == null) {
      Positions? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPositionsFromHive();
      return Response(
        msg: "Success: Updated Positions ${id}", 
        subClass: "Positions::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Positions::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Positions ${id}",
        subClass: "Positions::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await PositionsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadPositionsFromHive();
      return Response(
          msg: "Success: deleted Positions $id",
          subClass: "Positions::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Positions::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Positions $id",
      data : { "id" : $id },
      subClass: "Positions::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("PositionsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Positions",
          subClass: "Positions::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: PositionsSchema", 
      subClass: "Positions::schema",
      error: result.error);
    }
  }
}