import 'dart:convert';

import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../DataInitializer/DataFetchable.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'VendingMachine.dart';
import 'VendingMachineService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class VendingMachineProvider with ChangeNotifier implements DataFetchable{
  List<VendingMachine> _data = [];
  Box<VendingMachine> hiveBox = Hive.box<VendingMachine>('VendingMachinesBox');
  List<VendingMachine> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String query = """\$limit=10000&\$sort[createdAt]=-1&""";

  VendingMachineProvider() {
    loadVendingMachineFromHive();
  }

  void loadVendingMachineFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(VendingMachine item) async {
    _isLoading = true;
    final Result result = await VendingMachineService(query: query).create(item);
    if (result.error == null) {
      VendingMachine? data = result.data;
      hiveBox.put(data?.id, data!);
      loadVendingMachineFromHive();
      return Response(
          data: data,
          msg: "Success: created machine master ${item.name}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("VendingMachine create : ${result.error}");
      return Response(
          msg: "Failed: creating machine master ${item.name}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await VendingMachineService(query: query).fetchById(id);
    if (result.error == null) {
      VendingMachine? data = result.data;
      hiveBox.put(data?.id, data!);
      loadVendingMachineFromHive();
      return Response(
          data: data,
          msg: "Success: saved machine master $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("VendingMachine get one : ${result.error}");
      return Response(
          msg: "Failed: saving machine master $id", error: result.error);
    }
  }

  Future<Response> fetchOneBySerialNoAndSave(String serialNo) async {
    _isLoading = true;
    final Result result = await VendingMachineService(query: query).fetchByKeyValue("serialNo", serialNo);
    if (result.error == null) {
      VendingMachine? data = result.data;
      hiveBox.put(data?.id, data!);
      loadVendingMachineFromHive();
      return Response(
          data: data,
          msg: "Success: saved machine master $serialNo",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("VendingMachine get one : ${result.error}");
      return Response(
          msg: "Failed: saving machine master $serialNo", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await VendingMachineService(query: query).fetchAll();

    if (result.error == null) {
      List<VendingMachine>? data = result.data;

      logger.i("Fetched Machines: ${data?.length}"); // Debugging Log

      if (data == null || data.isEmpty) {
        logger.w("No machine data returned from API!");
      }

      var isEmpty = _data.isEmpty;
      data?.forEach((VendingMachine item) {
        // logger.i("Saving Machine ID: ${item.id}");
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });

      loadVendingMachineFromHive();

      return Response(
        msg: "Success: fetched all machines",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.e("Machine Master get all error: ${result.error}");
      return Response(
        msg: "Failed: fetch all machine master",
        error: result.error,
      );
    }
  }

  Future<Response> updateOneAndSave(String id, VendingMachine item) async {
    _isLoading = true;
    final Result result = await VendingMachineService().update(id, item);
    if (result.error == null) {
      VendingMachine? data = result.data;
      hiveBox.put(data?.id, data!);
      loadVendingMachineFromHive();
      return Response(
          msg: "Success: updated machine master $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("VendingMachine update : ${result.error}");
      return Response(
          msg: "Failed: updating machine master $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await VendingMachineService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadVendingMachineFromHive();
      return Response(
          msg: "Success: deleted machine master $id",
          statusCode: result.statusCode);
    } else {
      logger.i("VendingMachine delete : ${result.error}");
      return Response(
          msg: "Failed: deleting machine master $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("machineMasterSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of machine masters",
          statusCode: result.statusCode);
    } else {
      logger.i("VendingMachine schema data: ${result.data}");
      logger.i("VendingMachine schema error: ${result.error}");
      return Response(msg: "Failed: machineMastersSchema", error: result.error);
    }
  }
}
