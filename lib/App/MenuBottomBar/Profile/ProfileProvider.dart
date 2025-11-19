import 'dart:convert';

import '../../../Utils/Services/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import '../../../Utils/Globals.dart' as globals;
import '../../../Utils/Services/Response.dart';
import '../../../Utils/Services/Results.dart';
import '../../../Utils/Services/SchemaService.dart';
import '../../../Widgets/Users/User.dart';
import 'Profile.dart';
import 'ProfileService.dart';

class ProfileProvider with ChangeNotifier {
  List<Profile> _profiles = [];
  Box<Profile> profilesBox = Hive.box<Profile>('profilesBox');

  List<Profile> get profiles => _profiles;
  Logger logger = globals.logger;
  bool _isLoading = false;
  get data => null;
  bool get isLoading => _isLoading;

  String query = """
\$populate[0][path]=userId&\$populate[0][service]=users&\$populate[0][select][0]=name&\$populate[0][select][1]=email&\$populate[0][select][2]=status&\$populate[0][select][3]=createdAt&\$populate[0][select][4]=updatedAt&
\$populate[1][path]=department&\$populate[1][service]=departments&\$populate[1][select][0]=name&
\$populate[2][path]=section&\$populate[2][service]=sections&\$populate[2][select][0]=name&
\$populate[3][path]=position&\$populate[3][service]=positions&\$populate[3][select][0]=name&
\$populate[4][path]=role&\$populate[4][service]=roles&\$populate[4][select][0]=name&
\$populate[5][path]=manager&\$populate[5][service]=users&\$populate[5][select][0]=name&
\$populate[6][path]=company&\$populate[6][service]=companies&\$populate[6][select][0]=name&
\$populate[7][path]=branch&\$populate[7][service]=branches&\$populate[7][select][0]=name&
\$populate[8][path]=address&\$populate[8][service]=user_addresses&\$populate[8][select][0]=Street1&\$populate[8][select][1]=Street2&\$populate[8][select][2]=Poscode&
\$populate[9][path]=phone&\$populate[9][service]=user_phones&\$populate[9][select][0]=number
""";

  ProfileProvider() {
    loadFromHive();
  }

  void loadFromHive() {
    _isLoading = false;
    _profiles = profilesBox.values.toList();
    notifyListeners();
  }

  Future<Response> find(String key, String value) async {
    final Result result =
        await ProfileService(query: query.replaceAll(' ', "").replaceAll('\n', "")).fetchByKeyValue(key, value);
    if (result.error == null) {
      List<Profile>? profiles = result.data;
      if (profiles!.isNotEmpty) {
        for (var profile in profiles) {
          profilesBox.put(profile.id, profile);
        }
        loadFromHive();
      }
      return Response(
        data: profiles,
          msg:
              "Success: found key=$key & value=$value => count=${profiles.length}",
          statusCode: result.statusCode);
    } else {
      logger.i("Profile find : ${result.error}");
      return Response(
          msg: "Failed: to find key=$key & value=$value", error: result.error);
    }
  }

  Future<Response> createOneAndSave(Profile item) async {
    final Result result = await ProfileService().create(item);
    if (result.error == null) {
      Profile? data = result.data;
      profilesBox.put(data?.id, data!);
      return Response(
          msg: "Success: created profile ${item.name}",
          statusCode: result.statusCode);
    } else {
      logger.i("Profile create : ${result.error}");
      return Response(
          msg: "Failed: creating profile ${item.name}", error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(
    String id,
  ) async {
    final Result result = await ProfileService(query: query.replaceAll(' ', "").replaceAll('\n', "")).fetchById(id);
    if (result.error == null) {
      Profile? data = result.data;
      profilesBox.put(data?.id, data!);
      return Response(
          data: data,
          msg: "Success: saved profile $id",
          statusCode: result.statusCode
      );
    } else {
      logger.i("Profile get one : ${result.error}");
      return Response(msg: "Failed: saving profile $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    String? userPref = await getPref("user");
    User user = User.fromJson(jsonDecode(userPref!));
    final Result result = await ProfileService(
            query:
                "userId=${user.id}&${query.replaceAll(' ', "").replaceAll('\n', "")}")
        .fetchAll();
    if (result.error == null) {
      List<Profile>? profiles = result.data;

      profiles
          ?.forEach((Profile profile) => profilesBox.put(profile.id, profile));
      loadFromHive();
      return Response(
          msg: "Success: fetched all", statusCode: result.statusCode);
    } else {
      logger.i("Profiles get all : ${result.error}");
      return Response(msg: "Failed: fetch all", error: result.error);
    }
  }

  Future<Response> regex(String key, String value) async {
    final Result result =
    await ProfileService(query: query).fetchByRegex(key, value);
    if (result.error == null) {
      List<Profile>? profiles = result.data;
      if (profiles!.isNotEmpty) {
        for (var profile in profiles) {
          profilesBox.put(profile.id, profile);
        }
        loadFromHive();
      }
      return Response(
          msg:
          "Success: found key=$key & value=$value => count=${profiles.length}",
          statusCode: result.statusCode);
    } else {
      logger.i("Profile get one : ${result.error}");
      return Response(
          msg: "Failed: to find key=$key & value=$value", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Profile item) async {
    final Result result = await ProfileService().update(id, item);
    if (result.error == null) {
      Profile? data = result.data;
      profilesBox.put(data?.id, data!);
      return Response(
          msg: "Success: updated profile $id", statusCode: result.statusCode);
    } else {
      logger.i("Profile update : ${result.error}");
      return Response(msg: "Failed: updating profile $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    final Result result = await ProfileService().delete(id);
    if (result.error == null) {
      profilesBox.delete(id);
      loadFromHive();
      return Response(
          msg: "Success: deleted profile $id", statusCode: result.statusCode);
    } else {
      logger.i("Profile delete : ${result.error}");
      return Response(msg: "Failed: deleting profile $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("profilesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of users",
          statusCode: result.statusCode);
    } else {
      logger.i("Profile schema data: ${result.data}");
      logger.i("Profile schema error: ${result.error}");
      return Response(msg: "Failed: profilesSchema", error: result.error);
    }
  }
}
