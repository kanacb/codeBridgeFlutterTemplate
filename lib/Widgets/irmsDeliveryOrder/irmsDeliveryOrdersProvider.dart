import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'irmsDeliveryOrders.dart';
import 'irmsDeliveryOrdersService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'irmsDeliveryOrders.dart';
import 'irmsDeliveryOrdersService.dart';

class irmsDeliveryOrdersProvider with ChangeNotifier {
  List<irmsDeliveryOrders> _data = [];
  Box<irmsDeliveryOrders> hiveBox = Hive.box<irmsDeliveryOrders>('irmsDeliveryOrdersBox');
  List<irmsDeliveryOrders> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String query = "";

  irmsDeliveryOrdersProvider() {
    loadirmsDeliveryOrdersFromHive();
  }

  void loadirmsDeliveryOrdersFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(irmsDeliveryOrders item) async {
    _isLoading = true;
    final Result result = await irmsDeliveryOrdersService(query: query).create(item);
    if (result.error == null) {
      irmsDeliveryOrders? data = result.data;
      hiveBox.put(data?.id, data!);
      loadirmsDeliveryOrdersFromHive();
      return Response(
          data: data,
          msg: "Success: created customer purchase order ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("irmsDeliveryOrders create : ${result.error}");
      return Response(
          msg: "Failed: creating customer purchase order ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await irmsDeliveryOrdersService(query: query).fetchById(id);
    if (result.error == null) {
      irmsDeliveryOrders? data = result.data;
      hiveBox.put(data?.id, data!);
      loadirmsDeliveryOrdersFromHive();
      return Response(
          data: data,
          msg: "Success: saved customer purchase order $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("irmsDeliveryOrders get one : ${result.error}");
      return Response(msg: "Failed: saving customer purchase order $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await irmsDeliveryOrdersService(query: query).fetchAll();
    if (result.error == null) {
      List<irmsDeliveryOrders>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((irmsDeliveryOrders item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadirmsDeliveryOrdersFromHive();
      return Response(
          msg: "Success: fetched all customer purchase orders", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("irmsDeliveryOrderss get all error: ${result.error}");
      return Response(msg: "Failed: fetch all customer purchase orders", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, irmsDeliveryOrders item) async {
    _isLoading = true;
    final Result result = await irmsDeliveryOrdersService().update(id, item);
    if (result.error == null) {
      irmsDeliveryOrders? data = result.data;
      hiveBox.put(data?.id, data!);
      loadirmsDeliveryOrdersFromHive();
      return Response(
          msg: "Success: updated customer purchase order $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("irmsDeliveryOrders update : ${result.error}");
      return Response(msg: "Failed: updating customer purchase order $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await irmsDeliveryOrdersService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadirmsDeliveryOrdersFromHive();
      return Response(
          msg: "Success: deleted customer purchase order $id", statusCode: result.statusCode);
    } else {
      logger.i("irmsDeliveryOrders delete : ${result.error}");
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
      logger.i("irmsDeliveryOrderss schema data: ${result.data}");
      logger.i("irmsDeliveryOrderss schema error: ${result.error}");
      return Response(msg: "Failed: customerPurchaseOrdersSchema", error: result.error);
    }
  }
}
