import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'SampleDetails.dart';
import 'SampleDetailsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SampleDetailsProvider with ChangeNotifier {
  List<SampleDetails> _data = [];
  Box<SampleDetails> hiveBox = Hive.box<SampleDetails>('sampleDetailsBox');
  List<SampleDetails> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  SampleDetailsProvider() {
    loadSampleDetailsFromHive();
  }

  void loadSampleDetailsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(SampleDetails item) async {
    _isLoading = true;
    final Result result = await SampleDetailsService(query: query).create(item);
    if (result.error == null) {
      SampleDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSampleDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: created customer purchase order ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("SampleDetails create : ${result.error}");
      return Response(
          msg: "Failed: creating customer purchase order ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await SampleDetailsService(query: query).fetchById(id);
    if (result.error == null) {
      SampleDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSampleDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: saved customer purchase order $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("SampleDetails get one : ${result.error}");
      return Response(msg: "Failed: saving customer purchase order $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await SampleDetailsService(query: query).fetchAll();
    if (result.error == null) {
      List<SampleDetails>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((SampleDetails item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadSampleDetailsFromHive();
      return Response(
          msg: "Success: fetched all customer purchase orders", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("SampleDetails get all error: ${result.error}");
      return Response(msg: "Failed: fetch all customer purchase orders", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, SampleDetails item) async {
    _isLoading = true;
    final Result result = await SampleDetailsService().update(id, item);
    if (result.error == null) {
      SampleDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSampleDetailsFromHive();
      return Response(
          msg: "Success: updated customer purchase order $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("SampleDetails update : ${result.error}");
      return Response(msg: "Failed: updating customer purchase order $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await SampleDetailsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadSampleDetailsFromHive();
      return Response(
          msg: "Success: deleted customer purchase order $id", statusCode: result.statusCode);
    } else {
      logger.i("SampleDetails delete : ${result.error}");
      return Response(msg: "Failed: deleting customer purchase order $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("customerPurchaseOrdersSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of customer purchase orders",
          statusCode: result.statusCode);
    } else {
      logger.i("SampleDetails schema data: ${result.data}");
      logger.i("SampleDetails schema error: ${result.error}");
      return Response(msg: "Failed: customerPurchaseOrdersSchema", error: result.error);
    }
  }
}
