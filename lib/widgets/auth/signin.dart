import 'package:cb_flutter_template/widgets/auth/login.dart';
import 'package:flutter/material.dart';

import '../../controllers/authController.dart';
import '../components/buttons/textButtons.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late bool isKeyboard;
  late SnackBar snackBar;
  final nextScreen = LoginPage();

  fetchLogin(body) => signinControl(body);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        buildEmail(email),
        buildPassword(password),
        buildButton(context, formKey, "Sign In", email, password, isKeyboard, fetchLogin,
            snackBar, nextScreen)
      ]),
    );
  }
}
