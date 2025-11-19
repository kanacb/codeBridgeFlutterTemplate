import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'WarehouseMaster.dart';
import 'WarehouseMasterService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WarehouseMasterProvider with ChangeNotifier {
  List<WarehouseMaster> _data = [];
  Box<WarehouseMaster> hiveBox = Hive.box<WarehouseMaster>('warehouseMasterBox');
  List<WarehouseMaster> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String query = "";

  WarehouseMasterProvider() {
    loadWarehouseMasterFromHive();
  }

  void loadWarehouseMasterFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(WarehouseMaster item) async {
    _isLoading = true;
    final Result result = await WarehouseMasterService(query: query).create(item);
    if (result.error == null) {
      WarehouseMaster? data = result.data;
      hiveBox.put(data?.id, data!);
      loadWarehouseMasterFromHive();
      return Response(
          data: data,
          msg: "Success: created customer purchase order ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("WarehouseMaster create : ${result.error}");
      return Response(
          msg: "Failed: creating customer purchase order ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await WarehouseMasterService(query: query).fetchById(id);
    if (result.error == null) {
      WarehouseMaster? data = result.data;
      hiveBox.put(data?.id, data!);
      loadWarehouseMasterFromHive();
      return Response(
          data: data,
          msg: "Success: saved customer purchase order $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("WarehouseMaster get one : ${result.error}");
      return Response(msg: "Failed: saving customer purchase order $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await WarehouseMasterService(query: query).fetchAll();
    if (result.error == null) {
      List<WarehouseMaster>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((WarehouseMaster item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadWarehouseMasterFromHive();
      return Response(
          msg: "Success: fetched all customer purchase orders", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("WarehouseMaster get all error: ${result.error}");
      return Response(msg: "Failed: fetch all customer purchase orders", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, WarehouseMaster item) async {
    _isLoading = true;
    final Result result = await WarehouseMasterService().update(id, item);
    if (result.error == null) {
      WarehouseMaster? data = result.data;
      hiveBox.put(data?.id, data!);
      loadWarehouseMasterFromHive();
      return Response(
          msg: "Success: updated customer purchase order $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("WarehouseMaster update : ${result.error}");
      return Response(msg: "Failed: updating customer purchase order $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await WarehouseMasterService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadWarehouseMasterFromHive();
      return Response(
          msg: "Success: deleted customer purchase order $id", statusCode: result.statusCode);
    } else {
      logger.i("WarehouseMaster delete : ${result.error}");
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
      logger.i("WarehouseMaster schema data: ${result.data}");
      logger.i("WarehouseMaster schema error: ${result.error}");
      return Response(msg: "Failed: customerPurchaseOrdersSchema", error: result.error);
    }
  }
}
