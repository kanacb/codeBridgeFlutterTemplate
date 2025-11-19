import '../../Utils/Methods.dart';
import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'JobStationTicket.dart';
import 'JobStationTicketService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class JobStationTicketProvider with ChangeNotifier {
  List<JobStationTicket> _data = [];
  Box<JobStationTicket> hiveBox = Hive.box<JobStationTicket>('jobStationTicketsBox');
  List<JobStationTicket> get data => _data;
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
      {
        "path": "supervisorId",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "technicianId",
        "service": "profiles",
        "select": ["name"],
      },
    ],
  };

  JobStationTicketProvider() {
    loadJobStationTicketsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadJobStationTicketsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(JobStationTicket item) async {
    _isLoading = true;
    final Result result = await JobStationTicketService(query: query).create(item);
    if (result.error == null) {
      JobStationTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: created job station ticket ${item.id}",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("JobStationTicket create : ${result.error}");
      return Response(
          msg: "Failed: creating job station ticket ${item.id}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await JobStationTicketService(query: query).fetchById(id);
    if (result.error == null) {
      JobStationTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: saved job station ticket $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("JobStation Ticket get one : ${result.error}");
      return Response(msg: "Failed: saving job station ticket $id", error: result.error);
    }
  }

  Future<Response> fetchByIncomingTicketAndSave(String ticketId) async {
    _isLoading = true;
    final Result result = await JobStationTicketService(query: query).fetchByKeyValue("ticketId", ticketId);
    if (result.error == null) {
      List<JobStationTicket>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((JobStationTicket item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadJobStationTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: fetched job station tickets by incoming ticket",
          statusCode: result.statusCode
      );
    } else {
      _isLoading = false;
      logger.i("JobStationTicket fetch by incoming ticket error: ${result.error}");
      return Response(msg: "Failed: fetched job station tickets by incoming ticket", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await JobStationTicketService(query: query).fetchAll();
    if (result.error == null) {
      List<JobStationTicket>? data = result.data;

      if (data != null) {
        final fetchedIds = data.map((e) => e.id).toSet();
        final existingIds = hiveBox.keys.cast<String>().toSet();

        final idsToDelete = existingIds.difference(fetchedIds);
        for (var id in idsToDelete) {
          hiveBox.delete(id);
        }

        for (JobStationTicket item in data) {
          hiveBox.put(item.id, item);
        }
      }
      loadJobStationTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: fetched all job station tickets",
          statusCode: result.statusCode
      );
    } else {
      _isLoading = false;
      logger.i("JobStationTickets get all error: ${result.error}");
      return Response(msg: "Failed: fetch all job station tickets", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, JobStationTicket item) async {
    _isLoading = true;
    final Result result = await JobStationTicketService().update(id, item);
    if (result.error == null) {
      JobStationTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: updated job station ticket $id",
          statusCode: result.statusCode
      );
    } else {
      _isLoading = false;
      logger.i("JobStationTicket update : ${result.error}");
      return Response(msg: "Failed: updating job station ticket $id", error: result.error);
    }
  }

  Future<Response> patchOneAndSave(String id, Map<String, dynamic> patchJSON) async {
    _isLoading = true;
    final Result result = await JobStationTicketService(query: query).patch(id, patchJSON);
    if (result.error == null) {
      JobStationTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadJobStationTicketsFromHive();
      return Response(
          data: data,
          msg: "Success: patched job station ticket $id",
          statusCode: result.statusCode
      );
    } else {
      _isLoading = false;
      logger.i("JobStationTicket patch : ${result.error}");
      return Response(msg: "Failed: patching job station ticket $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await JobStationTicketService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadJobStationTicketsFromHive();
      return Response(
          msg: "Success: deleted job station ticket $id", statusCode: result.statusCode);
    } else {
      logger.i("JobStationTicket delete : ${result.error}");
      return Response(msg: "Failed: deleting job station ticket $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("jobStationTicketsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of job station tickets",
          statusCode: result.statusCode);
    } else {
      logger.i("JobStationTicket schema data: ${result.data}");
      logger.i("JobStationTicket schema error: ${result.error}");
      return Response(msg: "Failed: jobStationTicketsSchema", error: result.error);
    }
  }
}
