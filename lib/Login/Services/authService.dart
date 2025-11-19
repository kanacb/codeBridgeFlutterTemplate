  import 'dart:convert';
  import 'dart:io';
  import 'package:flutter/foundation.dart';
  import 'package:logger/logger.dart';
  import '../../Utils/Globals.dart' as globals;
  import '../../Utils/Services/Response.dart';
  import '../../Utils/Services/Results.dart';
  import '../../Utils/Services/SharedPreferences.dart';
  import '../../Widgets/Users/User.dart';
  import 'package:http/http.dart' as http;
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';

  import 'FCMService.dart';

  class AuthService {
    Logger logger = globals.logger;
    final storage = FlutterSecureStorage();

    Future<Response> login(String email, String password, bool remember) async {
      final http.Response response;

      if (kDebugMode) {
        print(globals.api);
      }

      try {
        response = await http.post(Uri.parse('${globals.api}/authentication'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'email': email,
              'password': password,
              'strategy': 'local'
            }));
      } on HttpException catch (f) {
        return Response(msg: "Failed: server error", error: f.toString());
      } on http.ClientException catch (f) {
        return Response(msg: "Failed: client error", error: f.toString());
      }

      try {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final result = jsonDecode(response.body);
          var token = result['accessToken'];
          await saveToken(token);
          User user = User.fromJson(result['user']);
          await savePref("user", jsonEncode(result['user']));
          await savePref("login", "yes");
          await savePref("remember", remember.toString());
          if (remember) {
            await saveCredentials(email, password);
          }

          final status = await getPref("login");
          logger.i("Login status : $status");
          final fcmId = await getPref('fcmId');
          final Response fcmResponse =
              await FCMService.saveFcmToken(fcmId, user, token);

          // if (kDebugMode) {
          //   print(fcmResponse.error!);
          // }
          return Response(
              msg: "Success: logged in",
              data: user,
              statusCode: response.statusCode);
        } else {
          logger.i("login response : ${response.statusCode} ");
          logger.i("login url : ${globals.api} ");
          return Response(msg: "Failed: Invalid credentials", error: "error");
        }
      } catch (e) {
        logger.i("login response : ${response.statusCode} ");
        logger.i("login response : ${e.toString()} ");
        return Response(msg: "Failed: login error", error: e.toString());
      }
    }

    Future<bool> trySilentLogin() async {
      final email = await storage.read(key: 'email');
      final password = await storage.read(key: 'password');

      if (email == null || password == null) return false;

      try {
        final response = await http.post(
            Uri.parse('${globals.api}/authentication'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'email': email,
              'password': password,
              'strategy': 'local'
            }));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final result = jsonDecode(response.body);
          var token = result['accessToken'];
          await saveToken(token);
          await savePref("user", jsonEncode(result['user']));
          await savePref("login", "yes");
          logger.i("Silent login success!");
          return true;
        }
      } catch (e) {
        logger.i("Silent login failed: $e");
      }
      return false;
    }

    Future<void> saveCredentials(String email, String password) async {
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);
    }

    Future reauthenticate() async {
      final accessToken = await getToken();

      final response = await http.post(Uri.parse('${globals.api}/authentication'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"strategy": 'jwt', 'accessToken' : accessToken}));

      if (response.statusCode == 201) {
        return true;
      } else {
        logger.i("reauthenticate ${response.statusCode}");
      }
      return false;
    }

    Future logout() async {
      final accessToken = await getToken();
      final response =
          await http.delete(Uri.parse('${globals.api}/authentication'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $accessToken',
              },
              body: jsonEncode(<String, dynamic>{'status': true}),
              encoding: Encoding.getByName("Utf8Codec"));

      logger.i("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        await savePref("login", "no");
        logger.i("logout success");
      } else {
        await savePref("login", "no");
        logger.i("logout failed");
      }
    }

    Future<User?> register(User user) async {
      User? user;
      final response = await http.post(Uri.parse('${globals.api}/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user));
      if (response.statusCode == 201) {
        user = User.fromJson(jsonDecode(response.body));
        return user;
      } else {
        logger.i("register");
        logger.i(response.statusCode);
      }
      return null;
    }

    Future<Result> changePassword(String password) async {
      try {
        final accessToken = await getToken();
        final response = await http
            .patch(Uri.parse('${globals.api}/users'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        }, body: {
          "password": password
        });

        final result = User.fromJson(jsonDecode(response.body)['data']);
        return Result(data: result, statusCode: response.statusCode);
      } catch (e) {
        logger.i(e);
        return Result(error: 'Error: $e');
      }
    }
  }
