import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'SalesOrderItems.dart';
import 'SalesOrderItemsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SalesOrderItemsProvider with ChangeNotifier {
  List<SalesOrderItems> _data = [];
  Box<SalesOrderItems> hiveBox = Hive.box<SalesOrderItems>('salesOrderItemsBox');
  List<SalesOrderItems> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String query = "";

  SalesOrderItemsProvider() {
    loadSalesOrderItemsFromHive();
  }

  void loadSalesOrderItemsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(SalesOrderItems item) async {
    _isLoading = true;
    final Result result = await SalesOrderItemsService(query: query).create(item);
    if (result.error == null) {
      SalesOrderItems? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSalesOrderItemsFromHive();
      return Response(
          data: data,
          msg: "Success: created customer purchase order ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("SalesOrderItems create : ${result.error}");
      return Response(
          msg: "Failed: creating customer purchase order ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await SalesOrderItemsService(query: query).fetchById(id);
    if (result.error == null) {
      SalesOrderItems? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSalesOrderItemsFromHive();
      return Response(
          data: data,
          msg: "Success: saved customer purchase order $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("SalesOrderItems get one : ${result.error}");
      return Response(msg: "Failed: saving customer purchase order $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await SalesOrderItemsService(query: query).fetchAll();
    if (result.error == null) {
      List<SalesOrderItems>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((SalesOrderItems item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadSalesOrderItemsFromHive();
      return Response(
          msg: "Success: fetched all customer purchase orders", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("SalesOrderItems get all error: ${result.error}");
      return Response(msg: "Failed: fetch all customer purchase orders", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, SalesOrderItems item) async {
    _isLoading = true;
    final Result result = await SalesOrderItemsService().update(id, item);
    if (result.error == null) {
      SalesOrderItems? data = result.data;
      hiveBox.put(data?.id, data!);
      loadSalesOrderItemsFromHive();
      return Response(
          msg: "Success: updated customer purchase order $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("SalesOrderItems update : ${result.error}");
      return Response(msg: "Failed: updating customer purchase order $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await SalesOrderItemsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadSalesOrderItemsFromHive();
      return Response(
          msg: "Success: deleted customer purchase order $id", statusCode: result.statusCode);
    } else {
      logger.i("SalesOrderItems delete : ${result.error}");
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
      logger.i("SalesOrderItems schema data: ${result.data}");
      logger.i("SalesOrderItems schema error: ${result.error}");
      return Response(msg: "Failed: customerPurchaseOrdersSchema", error: result.error);
    }
  }
}
