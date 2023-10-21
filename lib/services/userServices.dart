import 'package:cb_flutter_template/services/restClient.dart';

Future<dynamic> createUser(data) async {
  final response = await client().sevice('users').create(data);
  return response;
}

Future<dynamic> getAllUser() async {
  final response = await client().sevice('users').get();
  return response;
}

Future<dynamic> findUser(data) async {
  final response = await client().sevice('users').find(data);
  return response;
}

Future<dynamic> updateUser(data) async {
  final response = await client().sevice('users').update(data);
  return response;
}

Future<dynamic> patchUser(data) async {
  final response = await client().sevice('users').patch(data);
  return response;
}

Future<dynamic> deleteUser(data) async {
  final response = await client().sevice('users').delete(data);
  return response;
}
