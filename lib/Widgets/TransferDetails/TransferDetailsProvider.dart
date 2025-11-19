import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'TransferDetails.dart';
import 'TransferDetailsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TransferDetailsProvider with ChangeNotifier {
  List<TransferDetails> _data = [];
  Box<TransferDetails> hiveBox = Hive.box<TransferDetails>('transferDetailsBox');
  List<TransferDetails> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String query = "";

  TransferDetailsProvider() {
    loadTransferDetailsFromHive();
  }

  void loadTransferDetailsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(TransferDetails item) async {
    _isLoading = true;
    final Result result = await TransferDetailsService(query: query).create(item);
    if (result.error == null) {
      TransferDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTransferDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: created customer purchase order ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("TransferDetails create : ${result.error}");
      return Response(
          msg: "Failed: creating customer purchase order ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await TransferDetailsService(query: query).fetchById(id);
    if (result.error == null) {
      TransferDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTransferDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: saved customer purchase order $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("TransferDetails get one : ${result.error}");
      return Response(msg: "Failed: saving customer purchase order $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await TransferDetailsService(query: query).fetchAll();
    if (result.error == null) {
      List<TransferDetails>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((TransferDetails item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadTransferDetailsFromHive();
      return Response(
          msg: "Success: fetched all customer purchase orders", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("TransferDetails get all error: ${result.error}");
      return Response(msg: "Failed: fetch all customer purchase orders", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, TransferDetails item) async {
    _isLoading = true;
    final Result result = await TransferDetailsService().update(id, item);
    if (result.error == null) {
      TransferDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadTransferDetailsFromHive();
      return Response(
          msg: "Success: updated customer purchase order $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("TransferDetails update : ${result.error}");
      return Response(msg: "Failed: updating customer purchase order $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await TransferDetailsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadTransferDetailsFromHive();
      return Response(
          msg: "Success: deleted customer purchase order $id", statusCode: result.statusCode);
    } else {
      logger.i("TransferDetails delete : ${result.error}");
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
      logger.i("TransferDetails schema data: ${result.data}");
      logger.i("TransferDetails schema error: ${result.error}");
      return Response(msg: "Failed: customerPurchaseOrdersSchema", error: result.error);
    }
  }
}
