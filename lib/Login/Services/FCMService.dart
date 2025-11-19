import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../Utils/Globals.dart' as globals;
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Results.dart';
import '../../Utils/Services/SharedPreferences.dart';
import '../../Widgets/Users/User.dart';

class FCMService {
  Logger logger = globals.logger;

  static void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          print('Notification Payload: $payload');
          // Navigate to a specific screen or perform any action
        }
      },
    );
  }

  static Future<void> setupFCM() async {
    late FirebaseMessaging messaging;
    String? fcmToken;
    messaging = FirebaseMessaging.instance;

    // Request permissions (for iOS)
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get the FCM token
    fcmToken = await messaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $fcmToken');
    }

    // Store the token in sharePreferences
    final fcmId = await getPref("fcmId");
    if (fcmId == null || fcmToken != fcmId) {
      await savePref("fcmId", fcmToken!);
    }

    initializeNotifications();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received message: ${message.notification?.title}');
      }
      showNotification(message);
    });

    // Listen for background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print('Handling background message: ${message.notification?.title}');
    }
    showNotification(message);
  }

  static Future saveFcmToken(
      String? fcmId, User user, String accessToken) async {
    final http.Response response;
    final device = getDevice();
    try {
      response = await http.post(Uri.parse('${globals.api}/fcm'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(<String, dynamic>{
            'fcmId': fcmId,
            'valid': true,
            'device': device,
            "createdBy": user.id
          }),
          encoding: Encoding.getByName("Utf8Codec"));
    } on HttpException catch (f) {
      return Response(
          msg: "Failed: saveFcmToken server error", error: f.toString());
    } on http.ClientException catch (f) {
      return Response(
          msg: "Failed: saveFcmToken client error", error: f.toString());
    }

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final result = jsonDecode(response.body);
        return Response(
            msg: "Success: fcm token saved",
            data: result,
            statusCode: response.statusCode);
      } else {
        return Response(msg: "Failed: fcm token save", error: "error");
      }
    } catch (e) {
      return Response(msg: "Failed: save Fcm Token", error: e.toString());
    }
  }

  static String getDevice() {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "iOS";
    } else if (Platform.isFuchsia) {
      return "Fuchsia";
    } else if (Platform.isLinux) {
      return "Linux";
    } else if (Platform.isMacOS) {
      return "MacOS";
    } else if (Platform.isWindows) {
      return "Windows";
    } else {
      return Platform.localHostname;
    }
  }

  static void showNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
    );
  }
}
