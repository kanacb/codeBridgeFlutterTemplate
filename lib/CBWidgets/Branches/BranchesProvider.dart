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
import 'Branch.dart';
import 'BranchesService.dart';

class BranchesProvider with ChangeNotifier implements DataFetchable{
  List<Branch> _data = [];
  Box<Branch> hiveBox = Hive.box<Branch>('branchesBox');
  List<Branch> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  BranchesProvider() {
    loadBranchesFromHive();
  }

  void loadBranchesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Branch item) async {
    _isLoading = true;
    final Result result = await BranchesService(query: query).create(item);
    if (result.error == null) {
      Branch? data = result.data;
      hiveBox.put(data?.id, data!);
      loadBranchesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Branches",
          subClass: "Branches::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Branch? data = result.data;
      logger.i("Failed: creating Branches::createOneAndSave, error: ${result.error}, subClass: Branches::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Branches",
          subClass: "Branches::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await BranchesService(query: query).fetchById(id);
    if (result.error == null) {
      Branch? data = result.data;
      hiveBox.put(data?.id, data!);
      loadBranchesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Branches::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Branches::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Branches $id", 
        error: result.error, 
        subClass: "Branches::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await BranchesService(query: query).fetchAll();
    if (result.error == null) {
      List<Branch>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Branch item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadBranchesFromHive();
      return Response(
        msg: "Success: Fetched all Branches",
        subClass: "Branches::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Branches::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Branches", 
        subClass: "Branches::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Branch item) async {
    _isLoading = true;
    final Result result = await BranchesService().update(id, item);
    if (result.error == null) {
      Branch? data = result.data;
      hiveBox.put(data?.id, data!);
      loadBranchesFromHive();
      return Response(
        msg: "Success: Updated Branches ${id}", 
        subClass: "Branches::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Branches::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Branches ${id}",
        subClass: "Branches::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await BranchesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadBranchesFromHive();
      return Response(
          msg: "Success: deleted Branches $id",
          subClass: "Branches::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Branches::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Branches $id",
      data : { "id" : id.toString() },
      subClass: "Branches::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("BranchesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Branches",
          subClass: "Branches::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: BranchesSchema", 
      subClass: "Branches::schema",
      error: result.error);
    }
  }
}