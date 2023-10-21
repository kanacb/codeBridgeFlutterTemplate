import 'package:cb_flutter_template/home.dart';
import 'package:flutter/material.dart';

import '../../controllers/authController.dart';
import '../components/buttons/textButtons.dart';

class ForgotPage extends StatelessWidget {
  ForgotPage({Key? key}) : super(key: key);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late bool isKeyboard;
  late SnackBar snackBar;
  final nextScreen = const MyHomePage();

  controller(body) => forgotControl(body);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        buildEmail(email),
        buildPassword(password),
        buildButton(context, formKey, "Logim", email, password, isKeyboard, controller,
            snackBar, nextScreen)
      ]),
    );
  }
}