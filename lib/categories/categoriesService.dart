
import '../main.dart';
import 'package:vx_index/global.dart';
import 'package:vx_index/services/api.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

import 'categoryModel.dart';


class CategoriesAPI {
  Future<APIResponse<List<Category>>> getCategories() async {
    List<Category>? categories;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.find(
        serviceName: "categories",
        query: {},
      );
      logger.i(response["data"].toString());
      categories = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => Category.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occured, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occured, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: categories);
  }
}
