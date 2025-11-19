import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'IrmsWarehouseParts.dart';
import 'IrmsWarehousePartsService.dart';

class IrmsWarehousePartsProvider with ChangeNotifier {
  List<IrmsWarehouseParts> _data = [];
  Box<IrmsWarehouseParts> hiveBox = Hive.box<IrmsWarehouseParts>('irmsWarehousePartsBox');
  List<IrmsWarehouseParts> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";
  Map<String, dynamic> mapQuery = {
    "\$limit": 25000,
    "\$populate": [
      {
        "path": "createdBy",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "updatedBy",
        "service": "profiles",
        "select": ["name"]
      }
    ],
  };

  IrmsWarehousePartsProvider() {
    loadIrmsWarehousePartsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadIrmsWarehousePartsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(IrmsWarehouseParts item) async {
    _isLoading = true;
    final Result result = await IrmsWarehousePartsService(query: query).create(item);
    if (result.error == null) {
      IrmsWarehouseParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIrmsWarehousePartsFromHive();
      return Response(
          data: data,
          msg: "Success: created Irms Warehouse Part ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IrmsWarehouseParts create : ${result.error}");
      return Response(
          msg: "Failed: creating Irms Warehouse Parts ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await IrmsWarehousePartsService(query: query).fetchById(id);
    if (result.error == null) {
      IrmsWarehouseParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIrmsWarehousePartsFromHive();
      return Response(
          data: data,
          msg: "Success: saved Irms Warehouse Parts $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("IrmsWarehouseParts get one : ${result.error}");
      return Response(
          msg: "Failed: saving Irms Warehouse Parts $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await IrmsWarehousePartsService(query: query).fetchAll();
    if (result.error == null) {
      List<IrmsWarehouseParts>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((IrmsWarehouseParts item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadIrmsWarehousePartsFromHive();
      return Response(
          msg: "Success: fetched all Irms Warehouse Parts", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Irms Warehouse Parts get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Irms Warehouse Parts", error: result.error);
    }
  }

  Future<Response> fetchByPartIdAndSave(String partId) async {
    _isLoading = true;
    final Result result = await IrmsWarehousePartsService(query: query).fetchByKeyValue("part", partId);
    if (result.error == null) {
      List<IrmsWarehouseParts>? data = result.data;
      if (data!.isNotEmpty) {
        for (var part in data) {
          hiveBox.put(part.id, part);
        }
      }
      loadIrmsWarehousePartsFromHive();
      return Response(
          data: data,
          msg: "Success: fetched irms warehouse parts by part id",
          statusCode: result.statusCode
      );
    } else {
      _isLoading = false;
      logger.i("Irms Warehouse Parts get by part error: ${result.error}");
      return Response(msg: "Failed: fetch by part irms warehouse parts", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, IrmsWarehouseParts item) async {
    _isLoading = true;
    final Result result = await IrmsWarehousePartsService(query: query).update(id, item);
    if (result.error == null) {
      IrmsWarehouseParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIrmsWarehousePartsFromHive();
      return Response(
          msg: "Success: updated Irms Warehouse Parts $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Irms Warehouse Parts update : ${result.error}");
      return Response(
          msg: "Failed: updating Irms Warehouse Parts $id", error: result.error);
    }
  }

  Future<Response> patchOneAndSave(String id,  Map<String, dynamic> patchJSON) async {
    _isLoading = true;
    final Result result = await IrmsWarehousePartsService(query: query).patch(id, patchJSON);
    if (result.error == null) {
      IrmsWarehouseParts? data = result.data;
      hiveBox.put(data?.id, data!);
      loadIrmsWarehousePartsFromHive();
      return Response(
          data: data,
          msg: "Success: patched Irms Warehouse Parts $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Irms Warehouse Parts patched : ${result.error}");
      return Response(
          msg: "Failed: patched Irms Warehouse Parts $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await IrmsWarehousePartsService(query: query).delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadIrmsWarehousePartsFromHive();
      return Response(
          msg: "Success: deleted Irms Warehouse Parts $id",
          statusCode: result.statusCode);
    } else {
      logger.i("IrmsWarehouseParts delete : ${result.error}");
      return Response(
          msg: "Failed: deleting Irms Warehouse Parts $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("irmsWarehousePartsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of IrmsWarehouseParts",
          statusCode: result.statusCode);
    } else {
      logger.i("IrmsWarehouseParts schema data: ${result.data}");
      logger.i("IrmsWarehouseParts schema error: ${result.error}");
      return Response(
          msg: "Failed: IrmsWarehousePartsSchema", error: result.error);
    }
  }
}
