import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'DisposalDetails.dart';
import 'DisposalDetailsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DisposalDetailsProvider with ChangeNotifier {
  List<DisposalDetails> _data = [];
  Box<DisposalDetails> hiveBox = Hive.box<DisposalDetails>('disposalDetailsBox');
  List<DisposalDetails> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  DisposalDetailsProvider() {
    loadDisposalDetailsFromHive();
  }

  void loadDisposalDetailsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(DisposalDetails item) async {
    _isLoading = true;
    final Result result = await DisposalDetailsService(query: query).create(item);
    if (result.error == null) {
      DisposalDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDisposalDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: created customer purchase order ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DisposalDetails create : ${result.error}");
      return Response(
          msg: "Failed: creating customer purchase order ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await DisposalDetailsService(query: query).fetchById(id);
    if (result.error == null) {
      DisposalDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDisposalDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: saved customer purchase order $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DisposalDetails get one : ${result.error}");
      return Response(msg: "Failed: saving customer purchase order $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await DisposalDetailsService(query: query).fetchAll();
    if (result.error == null) {
      List<DisposalDetails>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((DisposalDetails item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadDisposalDetailsFromHive();
      return Response(
          msg: "Success: fetched all customer purchase orders", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DisposalDetails get all error: ${result.error}");
      return Response(msg: "Failed: fetch all customer purchase orders", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, DisposalDetails item) async {
    _isLoading = true;
    final Result result = await DisposalDetailsService().update(id, item);
    if (result.error == null) {
      DisposalDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDisposalDetailsFromHive();
      return Response(
          msg: "Success: updated customer purchase order $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DisposalDetails update : ${result.error}");
      return Response(msg: "Failed: updating customer purchase order $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await DisposalDetailsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadDisposalDetailsFromHive();
      return Response(
          msg: "Success: deleted customer purchase order $id", statusCode: result.statusCode);
    } else {
      logger.i("DisposalDetails delete : ${result.error}");
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
      logger.i("DisposalDetails schema data: ${result.data}");
      logger.i("DisposalDetails schema error: ${result.error}");
      return Response(msg: "Failed: customerPurchaseOrdersSchema", error: result.error);
    }
  }
}
