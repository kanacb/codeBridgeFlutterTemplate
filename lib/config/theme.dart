import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = false;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool getTheme() {
    return _isDark;
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
