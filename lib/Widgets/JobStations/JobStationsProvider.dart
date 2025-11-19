import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'JobStations.dart';
import 'JobStationsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class JobStationsProvider with ChangeNotifier {
  List<JobStations> _data = [];
  Box<JobStations> hiveBox = Hive.box<JobStations>('jobStationsBox');
  List<JobStations> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";
  Map<String, dynamic> mapQuery = {
    "\$limit": 1000,
    "\$populate": [
      {
        "path": "createdBy",
        "service": "users",
        "select": ["name"],
      },
      {
        "path": "updatedBy",
        "service": "users",
        "select": ["name"],
      },
    ],
  };

  JobStationsProvider() {
    loadJobStationsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadJobStationsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(JobStations item) async {
    _isLoading = true;
    final Result result = await JobStationsService(query: query).create(item);
    if (result.error == null) {
      JobStations? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationsFromHive();
      return Response(
          data: data,
          msg: "Success: created Job Station ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("JobStations create : ${result.error}");
      return Response(
          msg: "Failed: creating Job Stations ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await JobStationsService(query: query).fetchById(id);
    if (result.error == null) {
      JobStations? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationsFromHive();
      return Response(
          data: data,
          msg: "Success: saved Job Stations $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("JobStations get one : ${result.error}");
      return Response(
          msg: "Failed: saving Job Stations $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await JobStationsService(query: query).fetchAll();
    if (result.error == null) {
      List<JobStations>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((JobStations item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadJobStationsFromHive();
      return Response(
          msg: "Success: fetched all Job Stations", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Job Stations get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Job Stations", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, JobStations item) async {
    _isLoading = true;
    final Result result = await JobStationsService().update(id, item);
    if (result.error == null) {
      JobStations? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationsFromHive();
      return Response(
          msg: "Success: updated Job Stations $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Job Stations update : ${result.error}");
      return Response(
          msg: "Failed: updating Job Stations $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await JobStationsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadJobStationsFromHive();
      return Response(
          msg: "Success: deleted Job Stations $id",
          statusCode: result.statusCode);
    } else {
      logger.i("JobStations delete : ${result.error}");
      return Response(
          msg: "Failed: deleting Job Stations $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("jobStationsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of JobStations",
          statusCode: result.statusCode);
    } else {
      logger.i("JobStations schema data: ${result.data}");
      logger.i("JobStations schema error: ${result.error}");
      return Response(
          msg: "Failed: JobStationsSchema", error: result.error);
    }
  }
}
