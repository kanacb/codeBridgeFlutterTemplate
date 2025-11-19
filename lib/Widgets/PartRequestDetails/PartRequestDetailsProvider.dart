import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'PartRequestDetails.dart';
import 'PartRequestDetailsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PartRequestDetailsProvider with ChangeNotifier {
  List<PartRequestDetails> _data = [];
  Box<PartRequestDetails> hiveBox = Hive.box<PartRequestDetails>('partRequestDetailsBox');
  List<PartRequestDetails> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String query = "";
  Map<String, dynamic> mapQuery = {
    "\$limit": 1000,
    "\$populate": [
      {
        "path": "technician",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "approvedBy",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "createdBy",
        "service": "users",
        "select": ["name"],
      },
      {
        "path": "updatedBy",
        "service": "users",
        "select": ["name"],
      },
    ],
  };

  PartRequestDetailsProvider() {
    loadPartRequestDetailsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadPartRequestDetailsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(PartRequestDetails item) async {
    _isLoading = true;
    final Result result = await PartRequestDetailsService(query: query).create(item);
    if (result.error == null) {
      PartRequestDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPartRequestDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: created part request detail ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PartRequestDetails create : ${result.error}");
      return Response(
          msg: "Failed: creating part request detail ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await PartRequestDetailsService(query: query).fetchById(id);
    if (result.error == null) {
      PartRequestDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPartRequestDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: saved part request detail $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PartRequestDetails get one : ${result.error}");
      return Response(msg: "Failed: saving part request detail $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await PartRequestDetailsService(query: query).fetchAll();
    if (result.error == null) {
      List<PartRequestDetails>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((PartRequestDetails item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadPartRequestDetailsFromHive();
      return Response(
          msg: "Success: fetched all part request details", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PartRequestDetails get all error: ${result.error}");
      return Response(msg: "Failed: fetch all part request details", error: result.error);
    }
  }

  Future<Response> fetchByJobIdAndSave(String jobId) async {
    _isLoading = true;
    final Result result = await PartRequestDetailsService(query: query).fetchByKeyValue("jobId", jobId);
    if (result.error == null) {
      List<PartRequestDetails>? data = result.data;
      if (data!.isNotEmpty) {
        for (var detail in data) {
          hiveBox.put(detail.id, detail);
        }
      }
      loadPartRequestDetailsFromHive();
      return Response(
          data: data,
          msg: "Success: fetched part request details by jobId",
          statusCode: result.statusCode
      );
    } else {
      _isLoading = false;
      logger.i("PartRequestDetails get by jobId error: ${result.error}");
      return Response(msg: "Failed: fetch by jobId  part request details", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, PartRequestDetails item) async {
    _isLoading = true;
    final Result result = await PartRequestDetailsService(query: query).update(id, item);
    if (result.error == null) {
      PartRequestDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPartRequestDetailsFromHive();
      return Response(
          msg: "Success: updated part request detail $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("PartRequestDetails update : ${result.error}");
      return Response(msg: "Failed: updating part request detail $id", error: result.error);
    }
  }

  Future<Response> patchOneAndSave(String id,  Map<String, dynamic> patchJSON) async {
    _isLoading = true;
    final Result result = await PartRequestDetailsService(query: query).patch(id, patchJSON);
    if (result.error == null) {
      PartRequestDetails? data = result.data;
      hiveBox.put(data?.id, data!);
      loadPartRequestDetailsFromHive();
      return Response(
        data: data,
        msg: "Success: patched part request detail $id",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("PartRequestDetails patch : ${result.error}");
      return Response(msg: "Failed: patching part request detail $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await PartRequestDetailsService(query: query).delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadPartRequestDetailsFromHive();
      return Response(
          msg: "Success: deleted part request detail $id", statusCode: result.statusCode);
    } else {
      logger.i("PartRequestDetails delete : ${result.error}");
      return Response(msg: "Failed: deleting part request detail $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("PartRequestDetailsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of part request details",
          statusCode: result.statusCode);
    } else {
      logger.i("PartRequestDetails schema data: ${result.data}");
      logger.i("PartRequestDetails schema error: ${result.error}");
      return Response(msg: "Failed: PartRequestDetailsSchema", error: result.error);
    }
  }
}
