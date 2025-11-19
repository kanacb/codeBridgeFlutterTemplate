import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'QuotationItems.dart';
import 'QuotationItemsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class QuotationItemsProvider with ChangeNotifier {
  List<QuotationItems> _data = [];
  Box<QuotationItems> hiveBox = Hive.box<QuotationItems>('quotationItemsBox');
  List<QuotationItems> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String query = "";

  QuotationItemsProvider() {
    loadQuotationItemsFromHive();
  }

  void loadQuotationItemsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(QuotationItems item) async {
    _isLoading = true;
    final Result result = await QuotationItemsService(query: query).create(item);
    if (result.error == null) {
      QuotationItems? data = result.data;
      hiveBox.put(data?.id, data!);
      loadQuotationItemsFromHive();
      return Response(
          data: data,
          msg: "Success: created customer purchase order ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("QuotationItems create : ${result.error}");
      return Response(
          msg: "Failed: creating customer purchase order ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await QuotationItemsService(query: query).fetchById(id);
    if (result.error == null) {
      QuotationItems? data = result.data;
      hiveBox.put(data?.id, data!);
      loadQuotationItemsFromHive();
      return Response(
          data: data,
          msg: "Success: saved customer purchase order $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("QuotationItems get one : ${result.error}");
      return Response(msg: "Failed: saving customer purchase order $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await QuotationItemsService(query: query).fetchAll();
    if (result.error == null) {
      List<QuotationItems>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((QuotationItems item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadQuotationItemsFromHive();
      return Response(
          msg: "Success: fetched all customer purchase orders", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("QuotationItems get all error: ${result.error}");
      return Response(msg: "Failed: fetch all customer purchase orders", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, QuotationItems item) async {
    _isLoading = true;
    final Result result = await QuotationItemsService().update(id, item);
    if (result.error == null) {
      QuotationItems? data = result.data;
      hiveBox.put(data?.id, data!);
      loadQuotationItemsFromHive();
      return Response(
          msg: "Success: updated customer purchase order $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("QuotationItems update : ${result.error}");
      return Response(msg: "Failed: updating customer purchase order $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await QuotationItemsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadQuotationItemsFromHive();
      return Response(
          msg: "Success: deleted customer purchase order $id", statusCode: result.statusCode);
    } else {
      logger.i("QuotationItems delete : ${result.error}");
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
      logger.i("QuotationItems schema data: ${result.data}");
      logger.i("QuotationItems schema error: ${result.error}");
      return Response(msg: "Failed: customerPurchaseOrdersSchema", error: result.error);
    }
  }
}
