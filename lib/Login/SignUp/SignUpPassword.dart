import '../Login.dart';
import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import '../../Utils/Validators.dart';
import '../../Utils/Dialogs/BuildSvgIcon.dart';
import '../../Widgets/Users/User.dart';
import '../../Widgets/Users/UserProvider.dart';

class SignUpPassword extends StatefulWidget {
  const SignUpPassword({super.key, required this.name, required this.email});
  final String name;
  final String email;

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  late LabeledGlobalKey<FormState> key =
      LabeledGlobalKey<FormState>("Password");

  Utils utils = Utils();
  final Map<String, dynamic> formData = {};
  String password = "";
  String confirm = "";
  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSymbol = false;

  @override
  void initState() {
    super.initState();
    // Listen for focus changes on the TextFormField
  }

  void saveForm() async {
    formData['name'] = widget.name;
    formData['email'] = widget.email;
    formData['password'] = password;
    formData['is_email_verified'] = true;
    formData['status'] = true;
    formData['remember_token'] = true;
    // formData['email_verified_at'] = DateTime.now().toUtc().toIso8601String();
    formData['email_verified_at'] = true;
    formData['createdAt'] = DateTime.now().toUtc().toIso8601String();
    formData['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    print('Form Data: $formData');
    UserProvider userProvider = UserProvider();
    // Handle form submission logic here
    final data = User.fromJson(formData);
    Response response = await userProvider.createOneAndSave(data);
    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "successfully created user");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return const Login();
        },
      ), ModalRoute.withName('/'));
    } else {
      snackBar.FailedSnackBar(context, response.error!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BuildSvgIcon(
            assetName: "assets/svg/signup-password.svg",
            index: 1,
            currentIndex: 1),
      ),
      body: SafeArea(
        child: Form(
            key: key,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 2.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Set up your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Please enter your password and confirm password to proceed.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "New Password",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      if (!Validators.isPassword(value)) {
                        return "Password needs to be more than 10 characters";
                      }
                      if (!Validators.hasUppercase(value)) {
                        return "Password must contain at least one uppercase letter";
                      }
                      if (!Validators.hasNumber(value)) {
                        return "Password must contain at least one number";
                      }
                      if (!Validators.hasSymbol(value)) {
                        return "Password must contain at least one symbol";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        hasUppercase = Validators.hasUppercase(value);
                        hasSymbol = Validators.hasSymbol(value);
                        hasNumber = Validators.hasNumber(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: false,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // BuildSvgIcon(
                  //     assetName: "assets/svg/signup-password-policy.svg",
                  //     index: 1,
                  //     currentIndex: 2,
                  //     width: 90,
                  //     height: 90),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Text('Password needs an uppercase letter',
                          style: TextStyle(
                              color:
                              hasUppercase ? Colors.green : Colors.grey)),
                      Text('Password needs a number',
                          style: TextStyle(
                              color: hasNumber ? Colors.green : Colors.grey)),
                      Text('Password need a symbol',
                          style: TextStyle(
                              color: hasSymbol ? Colors.green : Colors.grey)),
                    ],
                  ),


                  const SizedBox(height: 20.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter confirm password";
                      }
                      if (value != password) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      confirm = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your confirm password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: false,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 120.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            saveForm();
                          }
                        },
                        child: const Text(
                          'Set up now',
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "© 2024 CodeBridge Sdn Bhd. All rights reserved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )),
      ),
    );
  }
}
