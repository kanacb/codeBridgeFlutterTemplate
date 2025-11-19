import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('authToken', token); // Store the token
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken'); // Retrieve the token
}

Future<void> savePref(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value); // Store the token
}

Future<String?> getPref(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key); // Retrieve the token
}

Future<void> clearPref() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<void> removePrefKey(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}