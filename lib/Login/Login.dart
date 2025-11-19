import 'package:flutter/material.dart';
import '../App/Dash/DashMain.dart';
import '../Widgets/DataInitializer/AppInitializerWidget.dart';
import 'Services/FCMService.dart';
import '../Utils/Services/Response.dart';
import '../Utils/Dialogs/SnackBars.dart';
import '../Utils/PageUtils.dart';
import '../Utils/Validators.dart';
import 'CantLogin.dart';
import 'Services/authService.dart';
import 'ForgotPassword.dart';
import 'SignUp/SignUpSetup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  String? email;
  String? password;
  late bool remember = false;
  late LabeledGlobalKey<FormState> key = LabeledGlobalKey<FormState>(
    "LoginForm",
  );

  Utils utils = Utils();
  AuthService auth = AuthService();
  SnackBars snackBars = SnackBars();

  bool shouldValidate = false;
  bool isLoggingIn = false;
  bool _loading = false;
  bool _passwordVisible = false;
  bool staffIdLogin = false;

  @override
  void initState() {
    super.initState();
    _get();
  }

  void _get() async {
    await FCMService.setupFCM();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: MediaQuery.of(context).size.width * 0.65,
            left: MediaQuery.of(context).size.width * 0.5,
            right: 0.2,
            child: Image.asset(
              'assets/images/login-background.png', // Replace with your image path
              fit: BoxFit.fitHeight,
              height:
                  MediaQuery.of(context).size.height *
                  0.3, // Cover top 30% of screen
            ),
          ),
          _loading
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink(),
          Form(
            autovalidateMode:
                shouldValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
            key: key,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 2.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Image.asset(
                      'assets/logos/atlas-logo.jpg', // Replace with your logo path
                      height: 123,
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              staffIdLogin ? "Staff Id" : "Email",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (staffIdLogin) {
                              if (Validators.isEmail(
                                value! + "@atlasirms.com.my",
                              )) {
                                return null;
                              }
                            } else if (Validators.isEmail(value)) {
                              return null;
                            }
                            return staffIdLogin
                                ? "Please enter valid Staff Id"
                                : "Please enter valid email";
                          },
                          onSaved: (value) {
                            if (staffIdLogin) {
                              email = value! + "@atlasirms.com.my";
                            } else
                              email = value!;
                          },
                          decoration: InputDecoration(
                            hintText:
                                staffIdLogin
                                    ? "Enter your valid staff id"
                                    : 'Enter your registered email',
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white60,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20,
                              24,
                              20,
                              24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          obscureText: !_passwordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (Validators.isPassword(value)) {
                              return null;
                            }
                            return "Please enter a valid password";
                          },
                          onSaved: (value) {
                            password = value!;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your Password',
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
                              20,
                              24,
                              20,
                              24,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: remember,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      remember = value!;
                                    });
                                  },
                                ),
                                const Text("Remember me"),
                              ],
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     // Add forgot password functionality
                            //     Navigator.of(context).push(
                            //       utils.createRoute(
                            //         context,
                            //         const Forgotpassword(),
                            //       ),
                            //     );
                            //   },
                            //   child: const Text(
                            //     "Forgot your password?",
                            //     style: TextStyle(color: Colors.red),
                            //   ),
                            // ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () async {
                                  if (key.currentState!.validate() && mounted) {
                                    key.currentState!.save();
                                    // print(email);
                                    // print(password);

                                    final Response response = await auth.login(
                                      email!,
                                      password!,
                                      remember,
                                    );
                                    setState(() {
                                      _loading = false;
                                    });
                                    if (response.error == null) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.greenAccent,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                35,
                                              ),
                                            ),
                                            content: Text(
                                              "Welcome onboard AIMS. Get ready to be awed.",
                                              style: TextStyle(
                                                color: Colors.black87,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            showCloseIcon: true,
                                            elevation: 2,
                                            duration: const Duration(seconds: 5),
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(5),
                                          ),
                                        );
                                        Navigator.of(context).pushReplacement(
                                          utils.createRoute(
                                            context,
                                            AppInitializerWidget(child: Dashboard(i: 1)),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.redAccent,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                35,
                                              ),
                                            ),
                                            content: Text(
                                              "Login - ${response.msg}",
                                            ),
                                            elevation: 2,
                                            duration: const Duration(seconds: 3),
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(5),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Haven\'t activated your account yet?',
                          style: TextStyle(fontSize: 10.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              utils.createRoute(context, const SignUpSetup()),
                            );
                          },
                          child: const Text(
                            ' Sign up now',
                            style: TextStyle(fontSize: 16.0, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     // Add "Can't log in?" functionality
                              //     Navigator.of(context).push(
                              //       utils.createRoute(context, const Cantlogin()),
                              //     );
                              //   },
                              //   child: const Text(
                              //     "Can't log in?",
                              //     style: TextStyle(color: Colors.blue),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  staffIdLogin = !staffIdLogin;
                                  setState(() {});
                                },
                                child: Text(
                                  staffIdLogin
                                      ? "Sign in with email"
                                      : "Sign in with staff id",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                          const Text(
                            "© 2024 CodeBridge Sdn Bhd. All rights reserved.",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
