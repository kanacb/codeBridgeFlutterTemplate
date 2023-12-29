import '../main.dart';
import 'package:vx_index/global.dart';
import 'package:vx_index/users/userModel.dart';
import 'package:vx_index/services/api.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

class UsersAPI {
  Future<APIResponse<List<User>>> getUsers() async {
    List<User>? users;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.find(
        serviceName: "users",
        query: {},
      );
      logger.i(response["data"].toString());
      users = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => User.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occured, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occured, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: users);
  }

  Future<APIResponse<List<User>>> patch(String id, Map<String, String> data) async {
    List<User>? user;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.patch(
          serviceName: "users",
          objectId: id,
          data: data
      );
      logger.i(response.toString());
      // user = List<Map<String, dynamic>>.from(response["data"])
      //     .map((map) => User.fromMap(map))
      //     .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occurred, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occurred, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: null);
  }
}
