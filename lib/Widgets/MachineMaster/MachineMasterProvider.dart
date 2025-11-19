import 'dart:convert';

import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'MachineMaster.dart';
import 'MachineMasterService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MachineMasterProvider with ChangeNotifier {
  List<MachineMaster> _data = [];
  Box<MachineMaster> hiveBox = Hive.box<MachineMaster>('machineMastersBox');
  List<MachineMaster> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String query = """\$limit=10&\$sort[createdAt]=-1&
  \$populate[0][path]=ownership&
  \$populate[0][service]=branches&
  \$populate[0][select][0]=_id&
  \$populate[0][select][1]=companyId&
  \$populate[0][select][2]=name&
  \$populate[0][select][3]=isDefault&
  \$populate[0][select][4]=createdBy&
  \$populate[0][select][5]=updatedBy&
  \$populate[0][select][6]=createdAt&
  \$populate[0][select][7]=updatedAt&
  \$populate[0][populate][path]=companyId&
  \$populate[0][populate][service]=companies&
  \$populate[0][populate][select][0]=name&
  \$populate[0][populate][select][1]=_id&
  \$populate[1][path]=vendingMachineType&
  \$populate[1][service]=vendingMachines&
  \$populate[1][select][0]=_id&
  \$populate[1][select][1]=name""".replaceAll("\n", "").replaceAll(" ", "");

  MachineMasterProvider() {
    loadMachineMastersFromHive();
  }

  void loadMachineMastersFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(MachineMaster item) async {
    _isLoading = true;
    final Result result = await MachineMasterService(query: query).create(item);
    if (result.error == null) {
      MachineMaster? data = result.data;
      hiveBox.put(data?.serialNumber, data!);
      loadMachineMastersFromHive();
      return Response(
          data: data,
          msg: "Success: created machine master ${item.serialNumber}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MachineMaster create : ${result.error}");
      return Response(
          msg: "Failed: creating machine master ${item.serialNumber}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await MachineMasterService(query: query).fetchById(id);
    if (result.error == null) {
      MachineMaster? data = result.data;
      hiveBox.put(data?.serialNumber, data!);
      loadMachineMastersFromHive();
      return Response(
          data: data,
          msg: "Success: saved machine master $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MachineMaster get one : ${result.error}");
      return Response(
          msg: "Failed: saving machine master $id", error: result.error);
    }
  }

  Future<Response> fetchOneBySerialNoAndSave(String serialNo) async {
    _isLoading = true;
    final Result result = await MachineMasterService(query: query).fetchByKeyValue("serialNumber", serialNo);
    // logger.i("result : ${result.data}");
    if (result.error == null) {
      MachineMaster? data = result.data;
      hiveBox.put(data?.serialNumber, data!);
      loadMachineMastersFromHive();
      return Response(
          data: data,
          msg: "Success: saved machine master $serialNo",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MachineMaster get one : ${result.error}");
      return Response(
          msg: "Failed: saving machine master $serialNo", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await MachineMasterService(query: query).fetchAll();

    if (result.error == null) {
      List<MachineMaster>? data = result.data;

      logger.i("Fetched Machines: ${data?.length}"); // Debugging Log

      if (data == null || data.isEmpty) {
        logger.w("No machine data returned from API!");
      }

      var isEmpty = _data.isEmpty;
      data?.forEach((MachineMaster item) {
        // logger.i("Saving Machine ID: ${item.id}");
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });

      loadMachineMastersFromHive();

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

  Future<Response> regex(String key, String value) async {
    final Result result =
    await MachineMasterService(query: query).fetchByRegex(key, value);
    if (result.error == null) {
      List<MachineMaster>? data = result.data;
      // if (data!.isNotEmpty) {
      //   for (var i in data) {
      //     hiveBox.put(i.id, i);
      //   }
      //   loadMachineMastersFromHive();
      // }
      return Response(
        data: data,
          msg:
          "Success: found key=$key & value=$value => count=${data?.length}",
          statusCode: result.statusCode);
    } else {
      logger.i("Machines regex : ${result.error}");
      return Response(
          msg: "Failed: to pattern key=$key & value=$value", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, MachineMaster item) async {
    _isLoading = true;
    final Result result = await MachineMasterService().update(id, item);
    if (result.error == null) {
      MachineMaster? data = result.data;
      hiveBox.put(data?.serialNumber, data!);
      loadMachineMastersFromHive();
      return Response(
          msg: "Success: updated machine master $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MachineMaster update : ${result.error}");
      return Response(
          msg: "Failed: updating machine master $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await MachineMasterService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadMachineMastersFromHive();
      return Response(
          msg: "Success: deleted machine master $id",
          statusCode: result.statusCode);
    } else {
      logger.i("MachineMaster delete : ${result.error}");
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
      logger.i("MachineMaster schema data: ${result.data}");
      logger.i("MachineMaster schema error: ${result.error}");
      return Response(msg: "Failed: machineMastersSchema", error: result.error);
    }
  }
}
