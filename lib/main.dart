import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Login/Services/authService.dart';
import 'App/Dash/DashMain.dart';
import 'Login/Login.dart';
import 'Utils/HiveSetup.dart';
import 'Utils/Services/SharedPreferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveSetup.initializeHive();
  ByteData data = await PlatformAssetBundle().load('assets/ca/fullchain.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  AuthService auth = AuthService();
  bool isLoggedIn = false;

  final remember = await getPref("remember");
  if (remember == 'true') {
    isLoggedIn = await auth.trySilentLogin();
  } else {
    isLoggedIn = await auth.reauthenticate();
  }


  runApp(
    MultiProvider(
      providers: HiveSetup().providers(),
      child:
          isLoggedIn
              ? MyAppDashBoard(status: isLoggedIn)
              : MyAppLogin(status: isLoggedIn),
    ),
  );
}

class MyAppLogin extends StatelessWidget {
  const MyAppLogin({super.key, required this.status});
  final bool status;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Atlas AIMS',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFFFC107), // Yellow
        colorScheme: ColorScheme.light(
          primary: Color(0xFFFFC107), // Yellow
          secondary: Color(0xFFE91E63), // Magenta
          background: Color(0xFFE0F7FA), // Teal
        ),
        scaffoldBackgroundColor: Color(0xFFFFFFFF), // White
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFC107), // Yellow
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE91E63), // Magenta
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          headlineSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        fontFamily: 'OpenSans', // Ensure this font is added to your project
      ),
      home: const Login(),
      routes: {'/login': (context) => const Login()},
    );
  }
}

class MyAppDashBoard extends StatelessWidget {
  const MyAppDashBoard({super.key, required this.status});
  final bool status;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Atlas AIMS',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFFFC107), // Yellow
        colorScheme: ColorScheme.light(
          primary: Color(0xFFFFC107), // Yellow
          secondary: Color(0xFFE91E63), // Magenta
          background: Color(0xFFE0F7FA), // Teal
        ),
        scaffoldBackgroundColor: Color(0xFFFFFFFF), // White
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFC107), // Yellow
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE91E63), // Magenta
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          headlineSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        fontFamily: 'OpenSans', // Ensure this font is added to your project
      ),
      home: Dashboard(i: 1),
      routes: {
        '/login': (context) => const Login(),
        '/settings': (context) => const Login(),
        '/manageCards': (context) => const Dashboard(i: 1),
        '/dashboard': (context) => const Dashboard(i: 0),
      },
    );
  }
}
