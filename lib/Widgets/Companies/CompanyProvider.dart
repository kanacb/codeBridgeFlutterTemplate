import '../../Widgets/DataInitializer/DataFetchable.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'Companies.dart';
import 'CompanyService.dart';

class CompanyProvider with ChangeNotifier implements DataFetchable {
  List<Companies> _data = [];
  Box<Companies> hiveBox = Hive.box<Companies>('CompaniesBox');
  List<Companies> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = """
  \$limit=10000&
  \$populate[0][path]=createdBy&
  \$populate[0][service]=users&
  \$populate[0][select][0]=name&
  \$populate[1][path]=updatedBy&
  \$populate[1][service]=users&
  \$populate[1][select][0]=name&
  """;

  CompanyProvider() {
    loadCompanysFromHive();
  }

  void loadCompanysFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Companies item) async {
    _isLoading = true;
    final Result result = await CompanyService(query: query).create(item);
    if (result.error == null) {
      Companies? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanysFromHive();
      return Response(
          data: data,
          msg: "Success: created atlas ticket ${item.name}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Companies create : ${result.error}");
      return Response(
          msg: "Failed: creating atlas ticket ${item.name}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await CompanyService(query: query).fetchById(id);
    if (result.error == null) {
      Companies? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanysFromHive();
      return Response(
          data: data,
          msg: "Success: saved atlas ticket $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Atlas Ticket get one : ${result.error}");
      return Response(msg: "Failed: saving atlas ticket $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await CompanyService(query: query).fetchAll();
    if (result.error == null) {
      List<Companies>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Companies item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadCompanysFromHive();
      return Response(
          msg: "Success: fetched all atlas tickets", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      return Response(msg: "Failed: fetch all atlas tickets", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Companies item) async {
    _isLoading = true;
    final Result result = await CompanyService().update(id, item);
    if (result.error == null) {
      Companies? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCompanysFromHive();
      return Response(
          msg: "Success: updated atlas ticket $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Companies update : ${result.error}");
      return Response(msg: "Failed: updating atlas ticket $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await CompanyService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadCompanysFromHive();
      return Response(
          msg: "Success: deleted atlas ticket $id", statusCode: result.statusCode);
    } else {
      logger.i("Companies delete : ${result.error}");
      return Response(msg: "Failed: deleting atlas ticket $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("CompanysSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of atlas tickets",
          statusCode: result.statusCode);
    } else {
      logger.i("Companies schema data: ${result.data}");
      logger.i("Companies schema error: ${result.error}");
      return Response(msg: "Failed: CompanysSchema", error: result.error);
    }
  }

}
