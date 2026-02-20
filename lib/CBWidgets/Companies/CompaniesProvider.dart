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
import 'Companies.dart';
import 'CompaniesService.dart';

class CompaniesProvider with ChangeNotifier implements DataFetchable{
  List<Companies> _data = [];
  Box<Companies> hiveBox = Hive.box<Companies>('companiesBox');
  List<Companies> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  CompaniesProvider() {
    loadCompaniesFromHive();
  }

  void loadCompaniesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Companies item) async {
    _isLoading = true;
    final Result result = await CompaniesService(query: query).create(item);
    if (result.error == null) {
      Companies? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompaniesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Companies",
          subClass: "Companies::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Companies? data = result.data;
      logger.i("Failed: creating Companies::createOneAndSave, error: ${result.error}, subClass: Companies::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Companies",
          subClass: "Companies::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await CompaniesService(query: query).fetchById(id);
    if (result.error == null) {
      Companies? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompaniesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Companies::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Companies::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Companies $id", 
        error: result.error, 
        subClass: "Companies::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await CompaniesService(query: query).fetchAll();
    if (result.error == null) {
      List<Companies>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Companies item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadCompaniesFromHive();
      return Response(
        msg: "Success: Fetched all Companies",
        subClass: "Companies::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Companies::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Companies", 
        subClass: "Companies::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Companies item) async {
    _isLoading = true;
    final Result result = await CompaniesService().update(id, item);
    if (result.error == null) {
      Companies? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompaniesFromHive();
      return Response(
        msg: "Success: Updated Companies ${id}", 
        subClass: "Companies::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Companies::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Companies ${id}",
        subClass: "Companies::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await CompaniesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadCompaniesFromHive();
      return Response(
          msg: "Success: deleted Companies $id",
          subClass: "Companies::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Companies::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Companies $id",
      data : { "id" : id.toString() },
      subClass: "Companies::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("CompaniesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Companies",
          subClass: "Companies::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: CompaniesSchema", 
      subClass: "Companies::schema",
      error: result.error);
    }
  }
}