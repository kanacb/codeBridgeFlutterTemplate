import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'CustomerPurchaseOrders.dart';
import 'CustomerPurchaseOrdersService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CustomerPurchaseOrdersProvider with ChangeNotifier {
  List<CustomerPurchaseOrders> _data = [];
  Box<CustomerPurchaseOrders> hiveBox = Hive.box<CustomerPurchaseOrders>('customerPurchaseOrdersBox');
  List<CustomerPurchaseOrders> get data => _data;
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

  CustomerPurchaseOrdersProvider() {
    loadCustomerPurchaseOrdersFromHive();
  }

  void loadCustomerPurchaseOrdersFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(CustomerPurchaseOrders item) async {
    _isLoading = true;
    final Result result = await CustomerPurchaseOrdersService(query: query).create(item);
    if (result.error == null) {
      CustomerPurchaseOrders? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCustomerPurchaseOrdersFromHive();
      return Response(
          data: data,
          msg: "Success: created customer purchase order ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("CustomerPurchaseOrder create : ${result.error}");
      return Response(
          msg: "Failed: creating customer purchase order ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await CustomerPurchaseOrdersService(query: query).fetchById(id);
    if (result.error == null) {
      CustomerPurchaseOrders? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCustomerPurchaseOrdersFromHive();
      return Response(
          data: data,
          msg: "Success: saved customer purchase order $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("CustomerPurchaseOrder get one : ${result.error}");
      return Response(msg: "Failed: saving customer purchase order $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await CustomerPurchaseOrdersService(query: query).fetchAll();
    if (result.error == null) {
      List<CustomerPurchaseOrders>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((CustomerPurchaseOrders item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadCustomerPurchaseOrdersFromHive();
      return Response(
          msg: "Success: fetched all customer purchase orders", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("CustomerPurchaseOrders get all error: ${result.error}");
      return Response(msg: "Failed: fetch all customer purchase orders", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, CustomerPurchaseOrders item) async {
    _isLoading = true;
    final Result result = await CustomerPurchaseOrdersService().update(id, item);
    if (result.error == null) {
      CustomerPurchaseOrders? data = result.data;
      hiveBox.put(data?.id, data!);
      loadCustomerPurchaseOrdersFromHive();
      return Response(
          msg: "Success: updated customer purchase order $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("CustomerPurchaseOrder update : ${result.error}");
      return Response(msg: "Failed: updating customer purchase order $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await CustomerPurchaseOrdersService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadCustomerPurchaseOrdersFromHive();
      return Response(
          msg: "Success: deleted customer purchase order $id", statusCode: result.statusCode);
    } else {
      logger.i("CustomerPurchaseOrder delete : ${result.error}");
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
      logger.i("CustomerPurchaseOrders schema data: ${result.data}");
      logger.i("CustomerPurchaseOrders schema error: ${result.error}");
      return Response(msg: "Failed: customerPurchaseOrdersSchema", error: result.error);
    }
  }
}
