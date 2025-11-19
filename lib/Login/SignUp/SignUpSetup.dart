import '../../Utils/Services/SharedPreferences.dart';
import 'SignUpVerify.dart';
import '../../Utils/Dialogs/BuildSvgIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/PageUtils.dart';
import '../../Utils/Validators.dart';
import '../../Widgets/MailQues/MailQueService.dart';

class SignUpSetup extends StatefulWidget {
  const SignUpSetup({super.key});

  @override
  _SignUpSetup createState() => _SignUpSetup();
}

class _SignUpSetup extends State<SignUpSetup> {
  late LabeledGlobalKey<FormState> key = LabeledGlobalKey<FormState>("Setup");
  String? email;
  String? name;

  Utils utils = Utils();
  SnackBars snackBars = SnackBars();

  @override
  void initState() {
    super.initState();
    // Listen for focus changes on the TextFormField
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
              assetName: "assets/svg/signup-setup.svg",
              index: 1,
              currentIndex: 1),
        ),
        body: Stack(children: [
          Positioned(
            top: MediaQuery.of(context).size.width * 0.80,
            left: MediaQuery.of(context).size.width * 0.5,
            right: 0,
            child: Image.asset(
              'assets/images/login-background.png', // Replace with your image path
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height *
                  0.3, // Cover top 30% of screen
            ),
          ),
          Form(
              key: key,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 2.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Set up your account",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Please enter your name and registered email to proceed.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (!Validators.hasLength(value, 150)) {
                          return "Please enter valid name less than 150 characters";
                        }
                        if (!Validators.isStringNotEmpty(value)) {
                          return "Name is required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Name',
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: false,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (Validators.isEmail(value)) {
                          return null;
                        }
                        return "Please enter valid email";
                      },
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your registered email',
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: false,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      flex: 3,
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
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                              MailQueService svr = MailQueService();
                              final Response response =
                                  await svr.createOnCodeVerify(
                                      name: name!, email: email!);
                              var code = await getPref("code");
                              print("code: $code");

                              if (response.isSuccess) {
                                Navigator.of(context).push(utils.createRoute(
                                    context,
                                    SignUpVerify(name: name!, email: email!, code:int.parse(code!))));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Code sent to email"),
                                    elevation: 2,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(5),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to send Code"),
                                    elevation: 2,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(5),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
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
                    const SizedBox(height: 24),
                  ],
                ),
              )),
        ]));
  }
}
