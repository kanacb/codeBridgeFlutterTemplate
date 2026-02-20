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
import 'CompanyAddresses.dart';
import 'CompanyAddressesService.dart';

class CompanyAddressesProvider with ChangeNotifier implements DataFetchable{
  List<CompanyAddresses> _data = [];
  Box<CompanyAddresses> hiveBox = Hive.box<CompanyAddresses>('companyAddressesBox');
  List<CompanyAddresses> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  CompanyAddressesProvider() {
    loadCompanyAddressesFromHive();
  }

  void loadCompanyAddressesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(CompanyAddresses item) async {
    _isLoading = true;
    final Result result = await CompanyAddressesService(query: query).create(item);
    if (result.error == null) {
      CompanyAddresses? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanyAddressesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved CompanyAddresses",
          subClass: "CompanyAddresses::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      CompanyAddresses? data = result.data;
      logger.i("Failed: creating CompanyAddresses::createOneAndSave, error: ${result.error}, subClass: CompanyAddresses::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating CompanyAddresses",
          subClass: "CompanyAddresses::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await CompanyAddressesService(query: query).fetchById(id);
    if (result.error == null) {
      CompanyAddresses? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanyAddressesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "CompanyAddresses::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: CompanyAddresses::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching CompanyAddresses $id", 
        error: result.error, 
        subClass: "CompanyAddresses::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await CompanyAddressesService(query: query).fetchAll();
    if (result.error == null) {
      List<CompanyAddresses>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((CompanyAddresses item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadCompanyAddressesFromHive();
      return Response(
        msg: "Success: Fetched all CompanyAddresses",
        subClass: "CompanyAddresses::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("CompanyAddresses::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all CompanyAddresses", 
        subClass: "CompanyAddresses::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, CompanyAddresses item) async {
    _isLoading = true;
    final Result result = await CompanyAddressesService().update(id, item);
    if (result.error == null) {
      CompanyAddresses? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanyAddressesFromHive();
      return Response(
        msg: "Success: Updated CompanyAddresses ${id}", 
        subClass: "CompanyAddresses::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("CompanyAddresses::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating CompanyAddresses ${id}",
        subClass: "CompanyAddresses::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await CompanyAddressesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadCompanyAddressesFromHive();
      return Response(
          msg: "Success: deleted CompanyAddresses $id",
          subClass: "CompanyAddresses::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("CompanyAddresses::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting CompanyAddresses $id",
      data : { "id" : id.toString() },
      subClass: "CompanyAddresses::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("CompanyAddressesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of CompanyAddresses",
          subClass: "CompanyAddresses::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: CompanyAddressesSchema", 
      subClass: "CompanyAddresses::schema",
      error: result.error);
    }
  }
}