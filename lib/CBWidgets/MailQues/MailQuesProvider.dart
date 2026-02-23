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
import 'MailQue.dart';
import 'MailQuesService.dart';

class MailQuesProvider with ChangeNotifier implements DataFetchable{
  List<MailQue> _data = [];
  Box<MailQue> hiveBox = Hive.box<MailQue>('mailQuesBox');
  List<MailQue> get data => _data;
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

  MailQuesProvider() {
    loadMailQuesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadMailQuesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(MailQue item) async {
    _isLoading = true;
    final Result result = await MailQuesService(query: query).create(item);
    if (result.error == null) {
      MailQue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMailQuesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved MailQues",
          subClass: "MailQues::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      MailQue? data = result.data;
      logger.i("Failed: creating MailQues::createOneAndSave, error: ${result.error}, subClass: MailQues::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating MailQues",
          subClass: "MailQues::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await MailQuesService(query: query).fetchById(id);
    if (result.error == null) {
      MailQue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMailQuesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "MailQues::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: MailQues::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching MailQues $id", 
        error: result.error, 
        subClass: "MailQues::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await MailQuesService(query: query).fetchAll();
    if (result.error == null) {
      List<MailQue>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((MailQue item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadMailQuesFromHive();
      return Response(
        msg: "Success: Fetched all MailQues",
        subClass: "MailQues::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MailQues::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all MailQues", 
        subClass: "MailQues::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, MailQue item) async {
    _isLoading = true;
    final Result result = await MailQuesService().update(id, item);
    if (result.error == null) {
      MailQue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadMailQuesFromHive();
      return Response(
        msg: "Success: Updated MailQues ${id}", 
        subClass: "MailQues::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("MailQues::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating MailQues ${id}",
        subClass: "MailQues::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await MailQuesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadMailQuesFromHive();
      return Response(
          msg: "Success: deleted MailQues $id",
          subClass: "MailQues::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("MailQues::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting MailQues $id",
      data : { "id" : id.toString() },
      subClass: "MailQues::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("MailQuesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of MailQues",
          subClass: "MailQues::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: MailQuesSchema", 
      subClass: "MailQues::schema",
      error: result.error);
    }
  }
}