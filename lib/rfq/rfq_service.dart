import 'package:flutter_feathersjs/flutter_feathersjs.dart';
import 'package:vx_index/rfq/rfq_model.dart';
import '../global.dart';
import '../main.dart';
import '../services/api.dart';

class RfqAPI {
  Future<APIResponse<List<RFQ>>> getRFqs() async {
    List<RFQ>? currencies;
    String? error;

    try {
      dynamic response = await flutterFeathersJS.rest.find(
        serviceName: "request4quote",
        query: {},
      );
      logger.i(response["data"].toString());
      currencies = List<Map<String, dynamic>>.from(response["data"])
          .map((map) => RFQ.fromMap(map))
          .toList();
    } on FeatherJsError catch (e) {
      logger.e(
          "FeatherJsError error ::: Type => ${e.type} ::: Message => ${e.message}");
      error =
          "Unexpected FeatherJsError occurred, please retry! ${e.toString()}";
    } catch (e) {
      logger.i("Unexpected error ::: ${e.toString()}");
      error = "Unexpected error occurred, please retry! ${e.toString()}";
    }
    return APIResponse(errorMessage: error, data: currencies);
  }
}
