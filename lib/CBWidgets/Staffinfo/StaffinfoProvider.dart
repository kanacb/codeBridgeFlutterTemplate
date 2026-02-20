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
import 'Staffinfo.dart';
import 'StaffinfoService.dart';

class StaffinfoProvider with ChangeNotifier implements DataFetchable{
  List<Staffinfo> _data = [];
  Box<Staffinfo> hiveBox = Hive.box<Staffinfo>('staffinfoBox');
  List<Staffinfo> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  StaffinfoProvider() {
    loadStaffinfoFromHive();
  }

  void loadStaffinfoFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Staffinfo item) async {
    _isLoading = true;
    final Result result = await StaffinfoService(query: query).create(item);
    if (result.error == null) {
      Staffinfo? data = result.data;
      hiveBox.put(data?.id, data!);
      loadStaffinfoFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Staffinfo",
          subClass: "Staffinfo::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Staffinfo? data = result.data;
      logger.i("Failed: creating Staffinfo::createOneAndSave, error: ${result.error}, subClass: Staffinfo::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Staffinfo",
          subClass: "Staffinfo::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await StaffinfoService(query: query).fetchById(id);
    if (result.error == null) {
      Staffinfo? data = result.data;
      hiveBox.put(data?.id, data!);
      loadStaffinfoFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Staffinfo::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Staffinfo::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Staffinfo $id", 
        error: result.error, 
        subClass: "Staffinfo::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await StaffinfoService(query: query).fetchAll();
    if (result.error == null) {
      List<Staffinfo>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Staffinfo item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadStaffinfoFromHive();
      return Response(
        msg: "Success: Fetched all Staffinfo",
        subClass: "Staffinfo::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Staffinfo::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Staffinfo", 
        subClass: "Staffinfo::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Staffinfo item) async {
    _isLoading = true;
    final Result result = await StaffinfoService().update(id, item);
    if (result.error == null) {
      Staffinfo? data = result.data;
      hiveBox.put(data?.id, data!);
      loadStaffinfoFromHive();
      return Response(
        msg: "Success: Updated Staffinfo ${id}", 
        subClass: "Staffinfo::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Staffinfo::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Staffinfo ${id}",
        subClass: "Staffinfo::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await StaffinfoService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadStaffinfoFromHive();
      return Response(
          msg: "Success: deleted Staffinfo $id",
          subClass: "Staffinfo::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Staffinfo::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Staffinfo $id",
      data : { "id" : $id },
      subClass: "Staffinfo::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("StaffinfoSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Staffinfo",
          subClass: "Staffinfo::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: StaffinfoSchema", 
      subClass: "Staffinfo::schema",
      error: result.error);
    }
  }
}