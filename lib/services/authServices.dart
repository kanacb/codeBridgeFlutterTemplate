import 'dart:convert';
import 'dart:io';
import 'package:cb_flutter_template/services/restClient.dart';

import 'deviceServices.dart';
import 'fcmServices.dart';

Future<dynamic> loginService(data) async {
  final response = await client().authenticate(
      userName: data["email"], password: data["password"]);
  return response;
}

Future<dynamic> signInService(data) async {
  final deviceInfo = await getDeviceInfo();
  final fcmInfo = await getFCMInfo();
  final body = jsonEncode(<String, dynamic>{
    'name': data['name'],
    'email': data['email'],
    'password': data['password'],
    'os': Platform.isAndroid ? 'android' : 'ios',
    'deviceInfo': deviceInfo,
    'fcmInfo': fcmInfo
  });

  final response = await client().service('users').create(body);
  return response;
}

Future<dynamic> forgotService(data) async {
  final response = await client().service('users').patch(data);
  return response;
}

Future<dynamic> resetService(data) async {
  final response = await client().service('users').patch(data);
  return response;
}

Future<dynamic> changeService(data) async {
  final response = await client().service('users').patch(data);
  return response;
}

Future<dynamic> reAuthenticate() async {
  final response = await client().reAuthenticate();
  return response;
}
