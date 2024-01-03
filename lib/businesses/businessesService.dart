import 'dart:convert';

import '../main.dart';
import 'package:vx_index/global.dart';
import 'businessModel.dart';
import 'package:vx_index/services/api.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

class BusinessesAPI {
  Future<APIResponse<List<Business>>> getBusinesses() async {
    List<Business>? businesses;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.find(
        serviceName: "businesses",
        query: {},
      );
      logger.i(response["data"].toString());
      businesses = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => Business.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occurred, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occurred, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: businesses);
  }

  Future<APIResponse<Business>> get(String id) async {
    Business? business;
    List<Business>? businesses;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.get(
        serviceName: "businesses",
        objectId: id,
      );
      business = Business.fromMap((jsonDecode(response.toString())));
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occurred, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occurred, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: business);
  }

  Future<APIResponse<List<Business>>> find(Map<String, String> params) async {
    List<Business>? businesses;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.find(
        serviceName: "businesses",
        query: params,
      );
      logger.i(response["data"].toString());
      businesses = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => Business.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occured, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occured, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: businesses);
  }
  Future<APIResponse<List<Business>>> patch(String id, Map<String, String> data) async {
    List<Business>? businesses;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.patch(
        serviceName: "businesses",
        objectId: id,
        data: data
      );
      logger.i(response["data"].toString());
      businesses = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => Business.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occured, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occured, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: businesses);
  }
  Future<APIResponse<List<Business>>> update(String id, Map<String, String> data) async {
    List<Business>? businesses;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.update(
          serviceName: "businesses",
          objectId: id,
          data: data
      );
      logger.i(response["data"].toString());
      businesses = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => Business.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occured, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occured, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: businesses);
  }
  Future<APIResponse<List<Business>>> create(Map<String, String> data) async {
    List<Business>? businesses;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.create(
        serviceName: "businesses",
        data: data,
      );
      logger.i(response["data"].toString());
      businesses = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => Business.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occured, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occured, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: businesses);
  }
  Future<APIResponse<List<Business>>> delete(String id) async {
    List<Business>? businesses;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.remove(
        serviceName: "businesses",
        objectId: id,
      );
      logger.i(response["data"].toString());
      businesses = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => Business.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occured, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occured, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: businesses);
  }
}
