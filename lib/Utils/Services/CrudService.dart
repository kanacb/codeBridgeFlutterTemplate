import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import '/Login/Services/authService.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '/Utils/Errors/ErrorCode409.dart';
import 'Schema.dart';
import '/Utils/Globals.dart' as globals;
import 'Results.dart';
import 'SharedPreferences.dart';

abstract class CrudService<T> {
  final String apiUrl;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final String? query;

  Logger logger = globals.logger;

  CrudService(this.apiUrl, this.query,
      {required this.fromJson, required this.toJson});

  Future<Result<T>> create(T item) async {
    http.Response response;

    try {
      final accessToken = await getToken();
      response = await http.post(
        Uri.parse("${globals.api}/$apiUrl?$query"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(toJson(item)),
      );
    } on HttpException catch (e) {
      return Result(error: "httpError: ${e.toString()}");
    } on http.ClientException catch (e) {
      return Result(error: "clientError: ${e.toString()}");
    }
    // logger.i(response.body);
    // logger.i(response.statusCode);
    // logger.i(jsonDecode(response.body));
    try {
      if (response.statusCode == 409) {
        return Result(
            statusCode: response.statusCode,
            error: ErrorCode409.fromJson(jsonDecode(response.body)).message);
      }
      final result = fromJson(jsonDecode(response.body));
      return Result(data: result, statusCode: response.statusCode);
    } catch (e) {
      return Result(
          error: 'Error: ${e.toString()}, statusCode: ${response.statusCode}');
    }
  }

  Future<Result<List<T>>> fetchByKeyValue(String key, String value) async {
    http.Response response;

    try {
      final accessToken = await getToken();
      final encodedSerialNo = Uri.encodeComponent(value);
      final String path = "${globals.api}/$apiUrl?$key=$encodedSerialNo&$query";
      log(Uri.parse("${globals.api}/$apiUrl?$key=$encodedSerialNo&$query").toString(), name: "DEBUG CrudService fetchByKeyValue: $apiUrl");
      response = await http.get(Uri.parse(path), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      final dataField = jsonDecode(response.body)['data'];
      final responseData = dataField is List ? dataField : [dataField];
      // logger.i(path);
      final result = responseData.map((data) => fromJson(data)).toList();
      return Result(data: result, statusCode: response.statusCode);
    } catch (e) {
      return Result(error: 'Error: $e');
    }
  }

  Future<Result<List<T>>> fetchByRegex(String key, String pattern) async {
    http.Response response;

    try {
      final accessToken = await getToken();
      // Build the regex query string for FeathersJS (MongoDB adapter)
      final regexQuery = '$key[\$regex]=$pattern&$key[\$options]=i';
      final String path = "${globals.api}/$apiUrl?$regexQuery&$query";
      log(Uri.parse(path).toString(), name: "DEBUG CrudService fetchByRegex: $apiUrl");

      // String temp = "https://app12.apps.uat.codebridge.live/machineMaster?query=%7B%22serialNumber%22%3A%7B%22%24regex%22%3A%2223802%22%2C%22%24options%22%3A%22i%22%7D%7D&\$limit=10";

      response = await http.get(Uri.parse(path), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });

      if (jsonDecode(response.body)['data'].runtimeType.toString() ==
          "List<dynamic>") {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        final result = data.map((json) => fromJson(json)).toList();
        return Result(data: result, statusCode: response.statusCode);
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body)['data'];
        logger.i(data);
        return Result(error: 'Error: ${data["name"]} - ${data["message"]}');
      }

    } catch (e) {
      return Result(error: 'Error: $e');
    }
  }

  Future<Result<T>> fetchById(String id) async {
    http.Response response;

    try {
      final accessToken = await getToken();
      log(Uri.parse("${globals.api}/$apiUrl/$id?$query").toString(), name: "DEBUG CrudService fetchById: $apiUrl");
      response = await http.get(Uri.parse("${globals.api}/$apiUrl/$id?$query"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });
      // logger.i(jsonDecode(response.body));
      final result = fromJson(jsonDecode(response.body));
      return Result(data: result, statusCode: response.statusCode);
    } catch (e) {
      return Result(error: 'Error: $e');
    }
  }

  Future<Result<T>> fetchByQuery() async {
    http.Response response;

    try {
      final accessToken = await getToken();
      response = await http.get(Uri.parse("${globals.api}/$apiUrl?$query"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });
    } on HttpException catch (e) {
      return Result(error: "httpError: ${e.toString()}");
    } on http.ClientException catch (e) {
      return Result(error: "clientError: ${e.toString()}");
    }

    try {
      final result = fromJson(jsonDecode(response.body)['data']);
      return Result(data: result, statusCode: response.statusCode);
    } catch (e) {
      return Result(error: 'Error: $e');
    }
  }

  Future<Result<List<T>>> fetchAll() async {
    http.Response response;

    try {
      final accessToken = await getToken();
      log(Uri.parse("${globals.api}/$apiUrl?$query").toString(), name: "DEBUG CrudService fetchAll: $apiUrl");
      response = await http.get(Uri.parse("${globals.api}/$apiUrl?$query"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });
    } on HttpException catch (e) {
      return Result(error: "httpError: ${e.toString()}");
    } on http.ClientException catch (e) {
      return Result(error: "clientError: ${e.toString()}");
    }
    // logger.i(response.body);
    // logger.i(response.statusCode);
    // logger.i(jsonDecode(response.body));
    try {
      if (jsonDecode(response.body)['data'].runtimeType.toString() ==
          "List<dynamic>") {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        final result = data.map((json) => fromJson(json)).toList();
        return Result(data: result, statusCode: response.statusCode);
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body)['data'];
        logger.i(data);
        return Result(error: 'Error: ${data["name"]} - ${data["message"]}');
      }
    } catch (e) {
      return Result(error: 'Error: ${e.toString()}');
    }
  }

  Future<Result<T>> update(String id, T item) async {
    http.Response response;

    try {
      final accessToken = await getToken();
      response = await http.put(
        Uri.parse("${globals.api}/$apiUrl/$id?$query"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(toJson(item)),
      );
    } on HttpException catch (e) {
      return Result(error: "httpError: ${e.toString()}");
    } on http.ClientException catch (e) {
      return Result(error: "clientError: ${e.toString()}");
    }

    try {
      final result = fromJson(jsonDecode(response.body));
      return Result(data: result, statusCode: response.statusCode);
    } catch (e) {
      return Result(error: 'Error: $e');
    }
  }

  Future<Result<T>> patch(String id, Map<String, dynamic> patchJSON) async {
    http.Response response;

    try {
      final accessToken = await getToken();
      response = await http.patch(
        Uri.parse("${globals.api}/$apiUrl/$id?$query"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(patchJSON),
      );
    } on HttpException catch (e) {
      return Result(error: "httpError: ${e.toString()}");
    } on http.ClientException catch (e) {
      return Result(error: "clientError: ${e.toString()}");
    }

    try {
      final result = fromJson(jsonDecode(response.body));
      return Result(data: result, statusCode: response.statusCode);
    } catch (e) {
      return Result(error: 'Error: $e');
    }
  }

  Future<Result<T?>> delete(String id) async {
    http.Response response;
    try {
      final accessToken = await getToken();
      response = await http.delete(Uri.parse('${globals.api}/$apiUrl/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });
    } on HttpException catch (e) {
      return Result(error: "httpError: ${e.toString()}");
    } on http.ClientException catch (e) {
      return Result(error: "clientError: ${e.toString()}");
    }

    return Result(statusCode: response.statusCode);
  }

  Future<Result<List<Schema>>> schema(String serviceSchemaName) async {
    http.Response response;
    try {
      final accessToken = await getToken();
      log(Uri.parse("${globals.api}/$serviceSchemaName").toString(), name: "DEBUG CrudService schema: $apiUrl");
      response = await http.get(Uri.parse('${globals.api}/$serviceSchemaName'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });
      // logger.i(jsonDecode(response.body));
    } on HttpException catch (e) {
      return Result(error: "httpError: ${e.toString()}");
    } on http.ClientException catch (e) {
      return Result(error: "clientError: ${e.toString()}");
    }

    try {
      final List<dynamic> data = jsonDecode(response.body);
      final result = data.map((json) => Schema.fromJson(json)).toList();
      return Result(data: result, statusCode: response.statusCode);
    } catch (e) {
      return Result(error: 'Error: $e');
    }
  }
}
