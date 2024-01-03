import 'package:dio/dio.dart';
import 'package:~cb-project-name~/screens/auth/login_screen.dart';
import 'package:~cb-project-name~/messages/messages_screen.dart';
import 'package:~cb-project-name~/screens/welcome/welcome_screen.dart';
import 'package:~cb-project-name~/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:~cb-project-name~/services/utils.dart';
import 'package:~cb-project-name~/components/users/users.model.dart';
// import 'package:socket_io_client/socket_io_client.dart' as socket;

FlutterFeathersjs flutterFeathersJS = FlutterFeathersjs()
  ..init(baseUrl: API.baseUrl, extraHeaders: {"auth": API.secret});
 main() {
  WidgetsFlutterBinding.ensureInitialized();
  Dio dio =
      Dio(BaseOptions(baseUrl: API.baseUrl, headers: {"auth": API.secret}));
  flutterFeathersJS.configure(FlutterFeathersjs.restClient(dio));

  // socket.Socket io = socket.io(API.baseUrl);
  // flutterFeathersJS.configure(FlutterFeathersjs.socketioClient(io));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget  {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 UsersModel? user;

  @override
  void initState() {
    super.initState();
    var thisUser = Utils.getItemFromLocalStorage("user");
    if (thisUser != null) {
      user = UsersModel.fromMap(thisUser!);
      print(thisUser.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '~cb-project-name~',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.orange,
        fontFamily: "Inter",
        scaffoldBackgroundColor: const Color(0xffF5F5F3),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: const TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: const TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.normal,
          ),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      home: user?.id != null ? WelcomeScreen(user: user!) : const LoginScreen(),
      routes: {
        '/logout' : (context) => const LoginScreen(),
        '/messages' : (context) => const MessagesScreen(),
        '/settings' : (context) => const MessagesScreen()
      },
    );
  }
}
