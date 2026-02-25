import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:logger/logger.dart';
import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import '../../CBWidgets/DataInitializer/DataFetchable.dart';
import 'DocumentStorage.dart';
import 'DocumentStoragesService.dart';

class DocumentStoragesProvider with ChangeNotifier implements DataFetchable{
  List<DocumentStorage> _data = [];
  Box<DocumentStorage> hiveBox = Hive.box<DocumentStorage>('documentStoragesBox');
  List<DocumentStorage> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final String query;
  Map<String, dynamic> mapQuery = {
  "limit": 1000,
  "\$sort": {
    "createdAt": -1
  },
  "\$populate": []
};

  DocumentStoragesProvider() {
    loadDocumentStoragesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadDocumentStoragesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(DocumentStorage item) async {
    _isLoading = true;
    final Result result = await DocumentStoragesService(query: query).create(item);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDocumentStoragesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved DocumentStorages",
          subClass: "DocumentStorages::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      DocumentStorage? data = result.data;
      logger.i("Failed: creating DocumentStorages::createOneAndSave, error: ${result.error}, subClass: DocumentStorages::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating DocumentStorages",
          subClass: "DocumentStorages::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await DocumentStoragesService(query: query).fetchById(id);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDocumentStoragesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "DocumentStorages::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: DocumentStorages::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching DocumentStorages $id", 
        error: result.error, 
        subClass: "DocumentStorages::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await DocumentStoragesService(query: query).fetchAll();
    if (result.error == null) {
      List<DocumentStorage>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((DocumentStorage item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadDocumentStoragesFromHive();
      return Response(
        msg: "Success: Fetched all DocumentStorages",
        subClass: "DocumentStorages::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DocumentStorages::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all DocumentStorages", 
        subClass: "DocumentStorages::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, DocumentStorage item) async {
    _isLoading = true;
    final Result result = await DocumentStoragesService().update(id, item);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDocumentStoragesFromHive();
      return Response(
        msg: "Success: Updated DocumentStorages ${id}", 
        subClass: "DocumentStorages::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DocumentStorages::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating DocumentStorages ${id}",
        subClass: "DocumentStorages::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await DocumentStoragesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadDocumentStoragesFromHive();
      return Response(
          msg: "Success: deleted DocumentStorages $id",
          subClass: "DocumentStorages::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("DocumentStorages::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting DocumentStorages $id",
      data : { "id" : id.toString() },
      subClass: "DocumentStorages::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("DocumentStoragesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of DocumentStorages",
          subClass: "DocumentStorages::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: DocumentStoragesSchema", 
      subClass: "DocumentStorages::schema",
      error: result.error);
    }
  }
}