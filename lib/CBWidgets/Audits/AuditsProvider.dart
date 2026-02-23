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
import 'Audit.dart';
import 'AuditsService.dart';

class AuditsProvider with ChangeNotifier implements DataFetchable{
  List<Audit> _data = [];
  Box<Audit> hiveBox = Hive.box<Audit>('auditsBox');
  List<Audit> get data => _data;
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

  AuditsProvider() {
    loadAuditsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadAuditsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Audit item) async {
    _isLoading = true;
    final Result result = await AuditsService(query: query).create(item);
    if (result.error == null) {
      Audit? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAuditsFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Audits",
          subClass: "Audits::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Audit? data = result.data;
      logger.i("Failed: creating Audits::createOneAndSave, error: ${result.error}, subClass: Audits::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Audits",
          subClass: "Audits::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await AuditsService(query: query).fetchById(id);
    if (result.error == null) {
      Audit? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAuditsFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Audits::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Audits::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Audits $id", 
        error: result.error, 
        subClass: "Audits::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await AuditsService(query: query).fetchAll();
    if (result.error == null) {
      List<Audit>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Audit item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadAuditsFromHive();
      return Response(
        msg: "Success: Fetched all Audits",
        subClass: "Audits::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Audits::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Audits", 
        subClass: "Audits::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Audit item) async {
    _isLoading = true;
    final Result result = await AuditsService().update(id, item);
    if (result.error == null) {
      Audit? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAuditsFromHive();
      return Response(
        msg: "Success: Updated Audits ${id}", 
        subClass: "Audits::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Audits::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Audits ${id}",
        subClass: "Audits::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await AuditsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadAuditsFromHive();
      return Response(
          msg: "Success: deleted Audits $id",
          subClass: "Audits::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Audits::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Audits $id",
      data : { "id" : id.toString() },
      subClass: "Audits::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("AuditsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Audits",
          subClass: "Audits::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: AuditsSchema", 
      subClass: "Audits::schema",
      error: result.error);
    }
  }
}