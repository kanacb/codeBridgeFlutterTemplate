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
import 'Profile.dart';
import 'ProfilesService.dart';

class ProfilesProvider with ChangeNotifier implements DataFetchable{
  List<Profile> _data = [];
  Box<Profile> hiveBox = Hive.box<Profile>('profilesBox');
  List<Profile> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";

  ProfilesProvider() {
    loadProfilesFromHive();
  }

  void loadProfilesFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Profile item) async {
    _isLoading = true;
    final Result result = await ProfilesService(query: query).create(item);
    if (result.error == null) {
      Profile? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProfilesFromHive();
      return Response(
          data: data,
          msg: "Success: Saved Profiles",
          subClass: "Profiles::createOneAndSave",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      Profile? data = result.data;
      logger.i("Failed: creating Profiles::createOneAndSave, error: ${result.error}, subClass: Profiles::fetchOneAndSave");
      return Response(
          msg: "Failed to create: creating Profiles",
          subClass: "Profiles::createOneAndSave",
          data : jsonEncode(data?.toJson()),
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await ProfilesService(query: query).fetchById(id);
    if (result.error == null) {
      Profile? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProfilesFromHive();
      return Response(
        data: data,
        msg: "Success: Fetched id:$id",
        subClass: "Profiles::fetchOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Failed: Profiles::fetchOneAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetching Profiles $id", 
        error: result.error, 
        subClass: "Profiles::fetchOneAndSave",
        data : { "id" : id});
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await ProfilesService(query: query).fetchAll();
    if (result.error == null) {
      List<Profile>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((Profile item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadProfilesFromHive();
      return Response(
        msg: "Success: Fetched all Profiles",
        subClass: "Profiles::fetchAllAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Profiles::fetchAllAndSave, error: ${result.error}");
      return Response(msg: "Failed: Fetched all Profiles", 
        subClass: "Profiles::fetchAllAndSave",
        error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Profile item) async {
    _isLoading = true;
    final Result result = await ProfilesService().update(id, item);
    if (result.error == null) {
      Profile? data = result.data;
      hiveBox.put(data?.id, data!);
      loadProfilesFromHive();
      return Response(
        msg: "Success: Updated Profiles ${id}", 
        subClass: "Profiles::updateOneAndSave",
        statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Profiles::updateOneAndSave, update : ${result.error}");
      return Response(msg: "Failed: updating Profiles ${id}",
        subClass: "Profiles::updateOneAndSave",
        id : id.toString(), 
        data : jsonEncode(item.toJson()),
        error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await ProfilesService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadProfilesFromHive();
      return Response(
          msg: "Success: deleted Profiles $id",
          subClass: "Profiles::deleteOne", 
          statusCode: result.statusCode);
    } else {
      logger.i("Profiles::deleteOne, error : ${result.error}");
      return Response(msg: "Failed: deleting Profiles $id",
      data : { "id" : id.toString() },
      subClass: "Profiles::deleteOne",
      error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("ProfilesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Profiles",
          subClass: "Profiles::schema",
          statusCode: result.statusCode);
    } else {
      logger.i("~cb-service-name-capitalize::schema, error: ${result.error}");
      return Response(msg: "Failed: ProfilesSchema", 
      subClass: "Profiles::schema",
      error: result.error);
    }
  }
}