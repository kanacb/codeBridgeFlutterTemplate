import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../../Utils/Globals.dart' as globals;
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import 'DocumentStorage.dart';
import 'DocumentStorageService.dart';

class DocumentStorageProvider with ChangeNotifier {
  List<DocumentStorage> _data = [];
  Box<DocumentStorage> hiveBox =
      Hive.box<DocumentStorage>('documentsStorageBox');
  List<DocumentStorage> get data => _data;
  Logger logger = globals.logger;
  String query = "";
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  DocumentStorageProvider() {
    loadFromHive();
  }

  void loadFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(DocumentStorage item) async {
    final Result result = await DocumentStorageService(query: query).create(item);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      return Response(
          msg: "Success: created profile ${item.name}",
          statusCode: result.statusCode);
    } else {
      logger.i("UserInvite create : ${result.error}");
      return Response(
          msg: "Failed: creating profile ${item.name}", error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    final Result result = await DocumentStorageService(query: query).fetchById(id);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      return Response(
          data: data,
          msg: "Success: saved profile $id",
          statusCode: result.statusCode);
    } else {
      logger.i("UserInvite get one : ${result.error}");
      return Response(msg: "Failed: saving profile $id", error: result.error);
    }
  }

  Future<Response> fetchByTableIdAndSave(String tableId) async {
    _isLoading = true;
    final Result result = await DocumentStorageService(query: query).fetchByKeyValue("tableId", tableId);
    if (result.error == null) {
      List<DocumentStorage>? data = result.data;
      data?.forEach((DocumentStorage item) => hiveBox.put(item.id, item));
      loadFromHive();
      return Response(
          data: data,
          msg: "Success: fetched by tableId",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DocumentStorages fetchByTableIdAndSave : ${result.error}");
      return Response(msg: "Failed: fetch by tableId", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    final Result result = await DocumentStorageService(query: query).fetchAll();
    if (result.error == null) {
      List<DocumentStorage>? inboxes = result.data;
      inboxes?.forEach((DocumentStorage item) => hiveBox.put(item.id, item));
      return Response(
          msg: "Success: fetched all", statusCode: result.statusCode);
    } else {
      logger.i("Profiles get all : ${result.error}");
      return Response(msg: "Failed: fetch all", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, DocumentStorage item) async {
    final Result result = await DocumentStorageService().update(id, item);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      return Response(
          msg: "Success: updated profile $id", statusCode: result.statusCode);
    } else {
      logger.i("UserInvite update : ${result.error}");
      return Response(msg: "Failed: updating profile $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    final Result result = await DocumentStorageService().delete(id);
    if (result.error == null) {
      hiveBox.delete(id);
      loadFromHive();
      return Response(
          msg: "Success: deleted profile $id", statusCode: result.statusCode);
    } else {
      logger.i("UserInvite delete : ${result.error}");
      return Response(msg: "Failed: deleting profile $id", error: result.error);
    }
  }
}
