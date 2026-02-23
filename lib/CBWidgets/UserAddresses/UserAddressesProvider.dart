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
import 'UserAddress.dart';
import 'UserAddressesService.dart';

class UserAddressesProvider with ChangeNotifier implements DataFetchable{
  List<UserAddress> _data = [];
  Box<UserAddress> hiveBox = Hive.box<UserAddress>('userAddressesBox');
  List<UserAddress> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final String query;
  Map<String, dynamic> mapQuery = {
  "limit": 1000,
  "\$sort": {
    "createdAt": -1
  },
  "\$populate": [
    {
      "path": "userId",
      "service": "users",
      "select": [
        "name",
        "email",
        "password",
        "status"
      ]
    }
  ]
};

  UserAddressesProvider() {
    loadUserAddressesFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadUserAddressesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(UserAddress item) async {
    _isLoading = true;
    final Result result = await UserAddressesService(query: query).create(item);
    if (result.error == null) {
      UserAddress? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserAddressesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved UserAddresses",
          subClass: "UserAddresses::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      UserAddress? data = result.data;
      logger.i("Failed: creating UserAddresses::createOneAndSave, error: ${result.error}, subClass: UserAddresses::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating UserAddresses",
          subClass: "UserAddresses::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await UserAddressesService(query: query).fetchById(id);
    if (result.error == null) {
      UserAddress? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserAddressesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "UserAddresses::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: UserAddresses::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching UserAddresses $id", 
        error: result.error, 
        subClass: "UserAddresses::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await UserAddressesService(query: query).fetchAll();
    if (result.error == null) {
      List<UserAddress>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((UserAddress item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadUserAddressesFromHive();
      return Response(
        msg: "Success: Fetched all UserAddresses",
        subClass: "UserAddresses::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserAddresses::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all UserAddresses", 
        subClass: "UserAddresses::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, UserAddress item) async {
    _isLoading = true;
    final Result result = await UserAddressesService().update(id, item);
    if (result.error == null) {
      UserAddress? data = result.data;
      hiveBox.put(data?.id, data!);
      loadUserAddressesFromHive();
      return Response(
        msg: "Success: Updated UserAddresses ${id}", 
        subClass: "UserAddresses::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("UserAddresses::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating UserAddresses ${id}",
        subClass: "UserAddresses::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await UserAddressesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadUserAddressesFromHive();
      return Response(
          msg: "Success: deleted UserAddresses $id",
          subClass: "UserAddresses::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("UserAddresses::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting UserAddresses $id",
      data : { "id" : id.toString() },
      subClass: "UserAddresses::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("UserAddressesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of UserAddresses",
          subClass: "UserAddresses::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: UserAddressesSchema", 
      subClass: "UserAddresses::schema",
      error: result.error);
    }
  }
}