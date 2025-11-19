import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../../Utils/Globals.dart' as globals;
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import 'CommentService.dart';
import 'Comment.dart';

class CommentProvider with ChangeNotifier {
  List<Comment> _comments = [];
  Box<Comment> commentBox = Hive.box<Comment>('commentsBox');
  List<Comment> get comments => _comments;
  Logger logger = globals.logger;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CommentProvider() {
    loadFromHive();
  }

  void loadFromHive() {
    _isLoading = false;
    _comments = commentBox.values.toList();
    notifyListeners();
  }

  Future<Response> createOneAndSave(Comment item) async {
    final Result result = await CommentService().create(item);
    if (result.error == null) {
      Comment? data = result.data;
      commentBox.put(data?.id, data!);
      return Response(
          msg: "Success: created profile ${item.text}",
          statusCode: result.statusCode);
    } else {
      logger.i("Comment create : ${result.error}");
      return Response(
          msg: "Failed: creating profile ${item.recordId}",
          error: result.error);
    }
  }

  Future<Response> fetchOneAndSave(String id) async {
    final Result result = await CommentService().fetchById(id);
    if (result.error == null) {
      Comment? data = result.data;
      commentBox.put(data?.id, data!);
      return Response(
          data: data,
          msg: "Success: saved profile $id",
          statusCode: result.statusCode);
    } else {
      logger.i("Comment get one : ${result.error}");
      return Response(msg: "Failed: saving profile $id", error: result.error);
    }
  }

  Future<Response> fetchAllAndSave() async {
    final Result result = await CommentService().fetchAll();
    if (result.error == null) {
      List<Comment>? inboxes = result.data;

      inboxes
          ?.forEach((Comment profile) => commentBox.put(profile.id, profile));
      return Response(
          msg: "Success: fetched all", statusCode: result.statusCode);
    } else {
      logger.i("Profiles get all : ${result.error}");
      return Response(msg: "Failed: fetch all", error: result.error);
    }
  }

  Future<Response> updateOneAndSave(String id, Comment item) async {
    final Result result = await CommentService().update(id, item);
    if (result.error == null) {
      Comment? data = result.data;
      commentBox.put(data?.id, data!);
      return Response(
          msg: "Success: updated profile $id", statusCode: result.statusCode);
    } else {
      logger.i("Comment update : ${result.error}");
      return Response(msg: "Failed: updating profile $id", error: result.error);
    }
  }

  Future<Response> deleteOne(String id) async {
    final Result result = await CommentService().delete(id);
    if (result.error == null) {
      commentBox.delete(id);
      loadFromHive();
      return Response(
          msg: "Success: deleted profile $id", statusCode: result.statusCode);
    } else {
      logger.i("Comment delete : ${result.error}");
      return Response(msg: "Failed: deleting profile $id", error: result.error);
    }
  }
}
