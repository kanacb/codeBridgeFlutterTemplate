
import '../main.dart';
import 'package:vx_index/global.dart';
import 'package:vx_index/services/api.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

import 'currencyModel.dart';


class CurrenciesAPI {
  Future<APIResponse<List<Currency>>> getCurrencies() async {
    List<Currency>? currencies;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.find(
        serviceName: "currencies",
        query: {},
      );
      logger.i(response["data"].toString());
      currencies = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => Currency.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error = "Unexpected FeatherJsError occurred, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occurred, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: currencies);
  }
}
