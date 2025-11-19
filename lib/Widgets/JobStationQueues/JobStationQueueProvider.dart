import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'JobStationQueue.dart';
import 'JobStationQueueService.dart';

class JobStationQueueProvider with ChangeNotifier {
  List<JobStationQueue> _data = [];
  Box<JobStationQueue> hiveBox = Hive.box<JobStationQueue>('jobStationQueuesBox');
  List<JobStationQueue> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = "";
  Map<String, dynamic> mapQuery = {
    "\$limit": 1000,
    "\$populate": [
      {
        "path": "selectedUser",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "jobStations.technicianId",
        "service": "profiles",
        "select": ["name"]
      }
    ],
  };

  JobStationQueueProvider() {
    loadJobStationQueueFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadJobStationQueueFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(JobStationQueue item) async {
    _isLoading = true;
    final Result result = await JobStationQueueService(query: query).create(item);
    if (result.error == null) {
      JobStationQueue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationQueueFromHive();
      return Response(
          data: data,
          msg: "Success: created Job Station ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("JobStationQueue create : ${result.error}");
      return Response(
          msg: "Failed: creating Job Stations ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await JobStationQueueService(query: query).fetchById(id);
    if (result.error == null) {
      JobStationQueue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationQueueFromHive();
      return Response(
          data: data,
          msg: "Success: saved Job Stations $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("JobStationQueue get one : ${result.error}");
      return Response(
          msg: "Failed: saving Job Stations $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await JobStationQueueService(query: query).fetchAll();
    if (result.error == null) {
      List<JobStationQueue>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((JobStationQueue item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadJobStationQueueFromHive();
      return Response(
          msg: "Success: fetched all Job Stations", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Job Stations get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Job Stations", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, JobStationQueue item) async {
    _isLoading = true;
    final Result result = await JobStationQueueService().update(id, item);
    if (result.error == null) {
      JobStationQueue? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationQueueFromHive();
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
    final Result result = await JobStationQueueService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadJobStationQueueFromHive();
      return Response(
          msg: "Success: deleted Job Stations $id",
          statusCode: result.statusCode);
    } else {
      logger.i("JobStationQueue delete : ${result.error}");
      return Response(
          msg: "Failed: deleting Job Stations $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("jobStationQueuesSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of JobStationQueue",
          statusCode: result.statusCode);
    } else {
      logger.i("JobStationQueue schema data: ${result.data}");
      logger.i("JobStationQueue schema error: ${result.error}");
      return Response(
          msg: "Failed: JobStationQueueSchema", error: result.error);
    }
  }
}
