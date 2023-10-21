import 'package:cb_flutter_template/controllers/userController.dart';

import '../services/authServices.dart';

Future<dynamic> loginControl(data) async {
  // do necessary checks
  // login control process here
  return loginService(data);
}

Future<dynamic> signinControl(data) async {
  // do necessary checks
  // create a new user using the User Controller
  return createUserControl(data);
}

// logout user
Future<dynamic> logoutControl(data) async {
  // clear token
  // do necessary checks
  // save data persistance
}

// reset password
Future<dynamic> resetControl(data) async {
  // do necessary checks
  // set the request to change password to true
}

// change password
Future<dynamic> changeControl(data) async {
  // do necessary checks
  // change password to new password
}

// forgot password
Future<dynamic> forgotControl(data) async {}

// reauthenticate
Future<dynamic> reauthControl(data) async {}
