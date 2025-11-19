import '../../Utils/Services/SchemaService.dart';
import 'package:logger/logger.dart';
import '../DataInitializer/DataFetchable.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Globals.dart' as globals;
import 'AtlasChecklists.dart';
import 'AtlasChecklistsService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AtlasChecklistsProvider with ChangeNotifier implements DataFetchable{
  List<AtlasChecklists> _data = [];
  Box<AtlasChecklists> hiveBox = Hive.box<AtlasChecklists>('atlasChecklistsBox');
  List<AtlasChecklists> get data => _data;
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

  AtlasChecklistsProvider() {
    loadAtlasChecklistsFromHive();
  }

  void loadAtlasChecklistsFromHive() {
    _isLoading = false;
    _data = hiveBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(AtlasChecklists item) async {
    _isLoading = true;
    try {
      final Result result =
      await AtlasChecklistsService(query: query).create(item);
      if (result.error == null) {
        AtlasChecklists? data = result.data;
        hiveBox.put(data?.id, data!);
        loadAtlasChecklistsFromHive();
        return Response(
            data: data,
            msg: "Success: created Atlas checklist ${item.name}",
            statusCode: result.statusCode);
      } else {
        _isLoading = false;
        logger.i("AtlasChecklist create error: ${result.error}");
        return Response(
            msg: "Failed: creating Atlas checklist ${item.name}",
            error: result.error);
      }
    } catch (e) {
      logger.i("AtlasChecklist create error: ${e.toString()}");
      return Response(
          msg: "Failed: creating Atlas checklist ${item.name}",
          error: e.toString());
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    _isLoading = true;
    final Result result = await AtlasChecklistsService().fetchById(id);
    if (result.error == null) {
      AtlasChecklists? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAtlasChecklistsFromHive();
      return Response(
          data: data,
          msg: "Success: saved Atlas checklist $id",
          statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Atlas checklist get one : ${result.error}");
      return Response(msg: "Failed: saving Atlas ticket $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    _isLoading = true;
    final Result result = await AtlasChecklistsService().fetchAll();
    if (result.error == null) {
      List<AtlasChecklists>? data = result.data;
      var isEmpty = false;
      if (_data.isEmpty) isEmpty = true;
      data?.forEach((AtlasChecklists item) {
        hiveBox.put(item.id, item);
        if (isEmpty) _data.add(item);
      });
      loadAtlasChecklistsFromHive();
      return Response(
          msg: "Success: fetched all Atlas checklists", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Atlas checklists get all error: ${result.error}");
      return Response(msg: "Failed: fetch all Atlas checklists", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, AtlasChecklists item) async {
    _isLoading = true;
    final Result result = await AtlasChecklistsService().update(id, item);
    if (result.error == null) {
      AtlasChecklists? data = result.data;
      hiveBox.put(data?.id, data!);
      loadAtlasChecklistsFromHive();
      return Response(
          msg: "Success: updated Atlas checklist $id", statusCode: result.statusCode);
    } else {
      _isLoading = false;
      logger.i("Atlas checklists update : ${result.error}");
      return Response(msg: "Failed: updating Atlas checklist $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    _isLoading = true;
    final Result result = await AtlasChecklistsService().delete(id);
    _isLoading = false;
    if (result.error == null) {
      hiveBox.delete(id);
      loadAtlasChecklistsFromHive();
      return Response(
          msg: "Success: deleted Atlas checklist $id", statusCode: result.statusCode);
    } else {
      logger.i("Atlas checklist delete : ${result.error}");
      return Response(msg: "Failed: deleting Atlas checklist $id", error: result.error);
    }
  }

  Future<Response> schema() async {
    _isLoading = true;
    final Result result = await SchemaService().schema("AtlasChecklistsSchema");
    _isLoading = false;
    if (result.error == null) {
      return Response(
          data: result.data,
          msg: "Success: schema of Atlas checklists",
          statusCode: result.statusCode);
    } else {
      logger.i("Atlas checklist schema data: ${result.data}");
      logger.i("Atlas checklist schema error: ${result.error}");
      return Response(msg: "Failed: AtlasChecklistsSchema", error: result.error);
    }
  }

}
