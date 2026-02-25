import 'dart:convert';
import 'dart:math';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../../Utils/Globals.dart' as globals;
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/SharedPreferences.dart';

class MailQuesServiceVerify {
  Logger logger = globals.logger;

  Future<Response> createOnCodeVerify({
    required String email,
    required String name,
  }) async {
    int code = Random().nextInt(999999);
    while (code < 100001) {
      code = Random().nextInt(999999);
    }

    http.Response response;

    try {
      response = await http.post(
        Uri.parse('${globals.api}/mailQues'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "name": "onCodeVerifyEmail",
          "type": "signup",
          "from": "admin@cloudbasha.com",
          "recipients": [email],
          "status": true,
          "data": {"name": name, "code": code.toString()}, // keep as string
          "subject": "email code verification process",
          "templateId": "onCodeVerify",
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await savePref("code", code.toString());
        return Response(
          msg: "sent mail",
          error: null,
          statusCode: response.statusCode,
        );
      } else {
        return Response(
          msg: "Failed to send mail",
          error: response.body,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      logger.i(e.toString());
      return Response(msg: "failed to send mail", error: e.toString());
    }
  }
}
