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
import 'DocumentStorageService.dart';

class DocumentStorageProvider with ChangeNotifier implements DataFetchable{
  List<DocumentStorage> _data = [];
  Box<DocumentStorage> hiveBox = Hive.box<DocumentStorage>('documentStorageBox');
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

  DocumentStorageProvider() {
    loadDocumentStorageFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadDocumentStorageFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(DocumentStorage item) async {
    _isLoading = true;
    final Result result = await DocumentStorageService(query: query).create(item);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDocumentStorageFromHive();
      return Response(
          data: data,
          msg: "Success: Saved DocumentStorage",
          subClass: "DocumentStorage::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      DocumentStorage? data = result.data;
      logger.i("Failed: creating DocumentStorage::createOneAndSave, error: ${result.error}, subClass: DocumentStorage::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating DocumentStorage",
          subClass: "DocumentStorage::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await DocumentStorageService(query: query).fetchById(id);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDocumentStorageFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "DocumentStorage::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: DocumentStorage::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching DocumentStorage $id", 
        error: result.error, 
        subClass: "DocumentStorage::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await DocumentStorageService(query: query).fetchAll();
    if (result.error == null) {
      List<DocumentStorage>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((DocumentStorage item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadDocumentStorageFromHive();
      return Response(
        msg: "Success: Fetched all DocumentStorage",
        subClass: "DocumentStorage::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DocumentStorage::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all DocumentStorage", 
        subClass: "DocumentStorage::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, DocumentStorage item) async {
    _isLoading = true;
    final Result result = await DocumentStorageService().update(id, item);
    if (result.error == null) {
      DocumentStorage? data = result.data;
      hiveBox.put(data?.id, data!);
      loadDocumentStorageFromHive();
      return Response(
        msg: "Success: Updated DocumentStorage ${id}", 
        subClass: "DocumentStorage::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("DocumentStorage::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating DocumentStorage ${id}",
        subClass: "DocumentStorage::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await DocumentStorageService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadDocumentStorageFromHive();
      return Response(
          msg: "Success: deleted DocumentStorage $id",
          subClass: "DocumentStorage::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("DocumentStorage::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting DocumentStorage $id",
      data : { "id" : id.toString() },
      subClass: "DocumentStorage::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("DocumentStorageSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of DocumentStorage",
          subClass: "DocumentStorage::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: DocumentStorageSchema", 
      subClass: "DocumentStorage::schema",
      error: result.error);
    }
  }
}