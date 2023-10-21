import 'package:cb_flutter_template/home.dart';
import 'package:flutter/material.dart';

import '../../controllers/authController.dart';
import '../components/buttons/textButtons.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late bool isKeyboard;
  late SnackBar snackBar = const SnackBar(
    content: Text("Invalid Login"),
    backgroundColor: Colors.red,
  );
  final nextScreen = const MyHomePage();

  fetchLogin(body) => loginControl(body);

  @override
  Widget build(BuildContext context) {
    isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Image.asset('lib/assets/images/welcome-banner.png', scale: 2.5,),
          const Text("CodeBridge App", style: TextStyle(fontSize: 30, color: Colors.red, fontFamily: "Times Roman"),),
        buildEmail(email),
      const SizedBox(height: 20.0),
        buildPassword(password),
        const SizedBox(height: 20.0),
        buildButton(context, formKey, "Login", email, password, isKeyboard,
            fetchLogin, snackBar, nextScreen)
      ]),
    );
  }
}
