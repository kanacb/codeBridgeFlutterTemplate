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
import 'CompanyPhone.dart';
import 'CompanyPhonesService.dart';

class CompanyPhonesProvider with ChangeNotifier implements DataFetchable{
  List<CompanyPhone> _data = [];
  Box<CompanyPhone> hiveBox = Hive.box<CompanyPhone>('companyPhonesBox');
  List<CompanyPhone> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final String query;
  Map<String, dynamic> mapQuery = {
  "limit": 1000,
  "\$sort": {
    "createdAt": -1
  },
  "\$populate": [
    {
      "path": "companyId",
      "service": "companies",
      "select": [
        "name",
        "companyNo",
        "newCompanyNumber",
        "DateIncorporated",
        "isdefault"
      ]
    }
  ]
};

  CompanyPhonesProvider() {
    loadCompanyPhonesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadCompanyPhonesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(CompanyPhone item) async {
    _isLoading = true;
    final Result result = await CompanyPhonesService(query: query).create(item);
    if (result.error == null) {
      CompanyPhone? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanyPhonesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved CompanyPhones",
          subClass: "CompanyPhones::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      CompanyPhone? data = result.data;
      logger.i("Failed: creating CompanyPhones::createOneAndSave, error: ${result.error}, subClass: CompanyPhones::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating CompanyPhones",
          subClass: "CompanyPhones::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await CompanyPhonesService(query: query).fetchById(id);
    if (result.error == null) {
      CompanyPhone? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanyPhonesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "CompanyPhones::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: CompanyPhones::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching CompanyPhones $id", 
        error: result.error, 
        subClass: "CompanyPhones::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await CompanyPhonesService(query: query).fetchAll();
    if (result.error == null) {
      List<CompanyPhone>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((CompanyPhone item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadCompanyPhonesFromHive();
      return Response(
        msg: "Success: Fetched all CompanyPhones",
        subClass: "CompanyPhones::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("CompanyPhones::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all CompanyPhones", 
        subClass: "CompanyPhones::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, CompanyPhone item) async {
    _isLoading = true;
    final Result result = await CompanyPhonesService().update(id, item);
    if (result.error == null) {
      CompanyPhone? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanyPhonesFromHive();
      return Response(
        msg: "Success: Updated CompanyPhones ${id}", 
        subClass: "CompanyPhones::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("CompanyPhones::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating CompanyPhones ${id}",
        subClass: "CompanyPhones::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await CompanyPhonesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadCompanyPhonesFromHive();
      return Response(
          msg: "Success: deleted CompanyPhones $id",
          subClass: "CompanyPhones::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("CompanyPhones::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting CompanyPhones $id",
      data : { "id" : id.toString() },
      subClass: "CompanyPhones::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("CompanyPhonesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of CompanyPhones",
          subClass: "CompanyPhones::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: CompanyPhonesSchema", 
      subClass: "CompanyPhones::schema",
      error: result.error);
    }
  }
}