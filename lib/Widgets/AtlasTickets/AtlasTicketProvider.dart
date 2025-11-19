import 'dart:convert';
import 'dart:developer';

import 'package:aims/Utils/Methods.dart';

import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import '../DataInitializer/DataFetchable.dart';
import 'AtlasTicket.dart';
import 'AtlasTicketService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AtlasTicketProvider with ChangeNotifier implements DataFetchable{
  List<AtlasTicket> _data = [];
  Box<AtlasTicket> hiveBox = Hive.box<AtlasTicket>('atlasTicketsBox');
  List<AtlasTicket> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  late final String query;
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
        "path": "assignedSupervisor",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "assignedTechnician",
        "service": "profiles",
        "select": ["name"],
      },
      {
        "path": "vendingController",
        "service": "profiles",
        "select": ["name"],
      },
    ],
  };

  AtlasTicketProvider() {
    loadAtlasTicketsFromHive();
    query = Methods.encodeQueryParameters(mapQuery);
  }

  void loadAtlasTicketsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(AtlasTicket item) async {
    _isLoading = true;

    //log(item.toString(), name: "DEBUG AtlasTicketProvider.dart createOneAndSave");
    final Result result = await AtlasTicketService(query: query).create(item);
    if (result.error == null) {
      AtlasTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAtlasTicketsFromHive();
      return Response(
        data: data,
        msg: "Success: created atlas ticket ${item.id}",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("atlasTicket create : ${result.error}");
      return Response(
        msg: "Failed: creating atlas ticket ${item.id}",
        error: result.error,
      );
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await AtlasTicketService(query: query).fetchById(id);
    if (result.error == null) {
      AtlasTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAtlasTicketsFromHive();
      return Response(
        data: data,
        msg: "Success: saved atlas ticket $id",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("Atlas Ticket get one : ${result.error}");
      return Response(
        msg: "Failed: saving atlas ticket $id",
        error: result.error,
      );
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await AtlasTicketService(query: query).fetchAll();
    //logger.i(result.data);
    if (result.error == null) {
      final data = result.data;

      if (data != null) {
        final fetchedIds = data.map((e) => e.id).toSet();
        final existingIds = hiveBox.keys.cast<String>().toSet();

        final idsToDelete = existingIds.difference(fetchedIds);
        for (var id in idsToDelete) {
          hiveBox.delete(id);
        }

        for (var item in data) {
          hiveBox.put(item.id, item);
        }
      }
      loadAtlasTicketsFromHive();
      return Response(
        msg: "Success: fetched all atlas tickets",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("AtlasTickets get all error: ${result.error}");
      return Response(
        msg: "Failed: fetch all atlas tickets",
        error: result.error,
      );
    }
  }

  Future<Response> updateOneAndSave(String id, AtlasTicket item) async {
    _isLoading = true;
    final Result result = await AtlasTicketService(
      query: query,
    ).update(id, item);
    if (result.error == null) {
      AtlasTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAtlasTicketsFromHive();
      return Response(
        msg: "Success: updated atlas ticket $id",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("AtlasTicket update : ${result.error}");
      return Response(
        msg: "Failed: updating atlas ticket $id",
        error: result.error,
      );
    }
  }

  Future<Response> patchOneAndSave(String id, Map<String, dynamic> patchJSON) async {
    _isLoading = true;
    final Result result = await AtlasTicketService(
      query: query,
    ).patch(id, patchJSON);
    if (result.error == null) {
      AtlasTicket? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAtlasTicketsFromHive();
      return Response(
        msg: "Success: patched atlas ticket $id",
        statusCode: result.statusCode,
      );
    } else {
      _isLoading = false;
      logger.i("AtlasTicket patch : ${result.error}");
      return Response(
        msg: "Failed: patching atlas ticket $id",
        error: result.error,
      );
    }
  }


  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await AtlasTicketService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadAtlasTicketsFromHive();
      return Response(
        msg: "Success: deleted atlas ticket $id",
        statusCode: result.statusCode,
      );
    } else {
      logger.i("AtlasTicket delete : ${result.error}");
      return Response(
        msg: "Failed: deleting atlas ticket $id",
        error: result.error,
      );
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("atlasTicketsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
        data: result.data,
        msg: "Success: schema of atlas tickets",
        statusCode: result.statusCode,
      );
    } else {
      logger.i("AtlasTicket schema data: ${result.data}");
      logger.i("AtlasTicket schema error: ${result.error}");
      return Response(msg: "Failed: atlasTicketsSchema", error: result.error);
    }
  }
}
