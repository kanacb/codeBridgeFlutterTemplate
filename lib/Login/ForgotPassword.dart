import '../../Login/Login.dart';
import 'package:flutter/material.dart';
import '../../Utils/Validators.dart';

import '../Utils/PageUtils.dart';

class Forgotpassword extends StatelessWidget {
  const Forgotpassword({super.key});

  @override
  Widget build(BuildContext context) {
    String email = "";
    final Utils utils = Utils();
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(
              top: 60.0, bottom: 2.0, left: 20.0, right: 20.0),
          child: Column(children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your logo path
              height: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Forgot your password?",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Please enter your registered email and we'll send you instructions to reset your password?",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (Validators.isEmail(value)) {
                  return null;
                }
                return "Please enter valid email";
              },
              onSaved: (value) {
                email = value!;
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
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 60.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onPressed: () {
                    // function to send email
                  },
                  child: const Text(
                    'Send reset instructions',
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                // Add "Back to login" functionality
                Navigator.of(context).pushReplacement(
                    utils.createRoute(context, const Login()));
              },
              child: const Text(
                "Back to login",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "© 2024 CodeBridge Sdn Bhd. All rights reserved.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ])),
    );
  }
}
