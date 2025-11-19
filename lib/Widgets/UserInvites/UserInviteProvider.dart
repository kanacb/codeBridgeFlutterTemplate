import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../../Utils/Globals.dart' as globals;
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import 'UserInviteService.dart';
import 'UserInvite.dart';

class UserInviteProvider with ChangeNotifier {
  List<UserInvite> _userInvites = [];
  Box<UserInvite> userInviteBox = Hive.box<UserInvite>('userInvitesBox');
  List<UserInvite> get userInvites => _userInvites;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String query = "";

  UserInviteProvider() {
    loadFromHive();
  }

  void loadFromHive() {
    _isLoading = false;
    _userInvites = userInviteBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(UserInvite item) async {
    final Result result = await UserInviteService(query: query).create(item);
    if (result.error == null) {
      UserInvite? data = result.data;
      userInviteBox.put(data?.id, data!);
      return Response(
          msg: "Success: created profile ${item.code}",
          statusCode: result.statusCode);
    } else {
      logger.i("UserInvite create : ${result.error}");
      return Response(
          msg: "Failed: creating profile ${item.code}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    final Result result = await UserInviteService(query: query).fetchById(id);
    if (result.error == null) {
      UserInvite? data = result.data;
      userInviteBox.put(data?.id, data!);
      return Response(
          data: data,
          msg: "Success: saved profile $id",
          statusCode: result.statusCode);
    } else {
      logger.i("UserInvite get one : ${result.error}");
      return Response(msg: "Failed: saving profile $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    final Result result = await UserInviteService(query: query).fetchAll();
    if (result.error == null) {
      List<UserInvite>? inboxes = result.data;

      inboxes
          ?.forEach((UserInvite profile) => userInviteBox.put(profile.id, profile));
      return Response(
          msg: "Success: fetched all", statusCode: result.statusCode);
    } else {
      logger.i("Profiles get all : ${result.error}");
      return Response(msg: "Failed: fetch all", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, UserInvite item) async {
    final Result result = await UserInviteService().update(id, item);
    if (result.error == null) {
      UserInvite? data = result.data;
      userInviteBox.put(data?.id, data!);
      return Response(
          msg: "Success: updated profile $id", statusCode: result.statusCode);
    } else {
      logger.i("UserInvite update : ${result.error}");
      return Response(msg: "Failed: updating profile $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    final Result result = await UserInviteService().delete(id);
    if (result.error == null) {
      userInviteBox.delete(id);
      loadFromHive();
      return Response(
          msg: "Success: deleted profile $id", statusCode: result.statusCode);
    } else {
      logger.i("UserInvite delete : ${result.error}");
      return Response(msg: "Failed: deleting profile $id", error: result.error);
    }
  }
}
