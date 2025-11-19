import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../DataInitializer/DataFetchable.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'AtlasChecks.dart';
import 'AtlasChecksService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AtlasChecksProvider with ChangeNotifier implements DataFetchable{
  List<AtlasChecks> _data = [];
  Box<AtlasChecks> hiveBox = Hive.box<AtlasChecks>('atlasChecksBox');
  List<AtlasChecks> get data => _data;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String query = """
  \$limit=10000&
  \$populate[0][path]=createdBy&
  \$populate[0][service]=users&
  \$populate[0][select][0]=name&
  \$populate[1][path]=updatedBy&
  \$populate[1][service]=users&
  \$populate[1][select][0]=name""";

  AtlasChecksProvider() {
    loadAtlasChecksFromHive();
  }

  void loadAtlasChecksFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(AtlasChecks item) async {
    _isLoading = true;
    try {
      final Result result =
      await AtlasChecksService(query: query).create(item);
      if (result.error == null) {
        AtlasChecks? data = result.data;
        hiveBox.put(data?.id, data!);
        loadAtlasChecksFromHive();
        return Response(
            data: data,
            msg: "Success: created Atlas check ${item.name}",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("Atlas Check create error: ${result.error}");
        return Response(
            msg: "Failed: creating Atlas check ${item.name}",
            error: result.error);
      }
    } catch (e) {
      logger.i("AtlasCheck create error: ${e.toString()}");
      return Response(
          msg: "Failed: creating Atlas check ${item.name}",
          error: e.toString());
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await AtlasChecksService(query: query).fetchById(id);
    if (result.error == null) {
      AtlasChecks? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAtlasChecksFromHive();
      return Response(
          data: data,
          msg: "Success: saved Atlas ticket $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Atlas Ticket get one : ${result.error}");
      return Response(msg: "Failed: saving Atlas ticket $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await AtlasChecksService().fetchAll();
    if (result.error == null) {
      List<AtlasChecks>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((AtlasChecks item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadAtlasChecksFromHive();
      return Response(
          msg: "Success: fetched all Atlas tickets", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Atlas Tickets get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Atlas tickets", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, AtlasChecks item) async {
    _isLoading = true;
    final Result result = await AtlasChecksService(query: query).update(id, item);
    if (result.error == null) {
      AtlasChecks? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAtlasChecksFromHive();
      return Response(
          msg: "Success: updated Atlas ticket $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("EAtlasTicket update : ${result.error}");
      return Response(msg: "Failed: updating Atlas ticket $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await AtlasChecksService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadAtlasChecksFromHive();
      return Response(
          msg: "Success: deleted Atlas ticket $id", statusCode: result.statusCode);
    } else {
      logger.i("AtlasTicket delete : ${result.error}");
      return Response(msg: "Failed: deleting Atlas ticket $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("AtlasChecksSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Atlas checks",
          statusCode: result.statusCode);
    } else {
      logger.i("AtlasTicket schema data: ${result.data}");
      logger.i("AtlasTicket schema error: ${result.error}");
      return Response(msg: "Failed: AtlasChecksSchema", error: result.error);
    }
  }


}
