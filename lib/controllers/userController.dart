import '../services/userServices.dart';

Future<dynamic> createUserControl(data) async {
  // do necessary checks
  return createUser(data);
}

Future<dynamic> findUserControl(data) async {
  // do necessary checks
  return findUser(data);
}

Future<dynamic> getAllUserControl() async {
  // do necessary checks
  return getAllUser();
}

Future<dynamic> updateUserControl(data) async {
  // do necessary checks
  return updateUser(data);
}

Future<dynamic> patchUserControl(data) async {
  // do necessary checks
  return patchUser(data);
}

Future<dynamic> deleteUserControl(data) async {
  return deleteUser(data);
}
