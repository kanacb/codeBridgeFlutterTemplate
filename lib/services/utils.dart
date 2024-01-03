import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:moment_dart/moment_dart.dart';

class Utils {
  static final LocalStorage storage = LocalStorage('cb_app');

  static void addItemsToLocalStorage(String key, Map<String, dynamic> data) {
    storage.setItem(key, data);
  }

  static Map<String, dynamic>? getItemFromLocalStorage(String key) {
    var item = storage.getItem(key);
    if (item != null) {
      Map<String, dynamic> item = storage.getItem(key);
      return item;
    }
    return null;
  }

  static void removeItemFromLocalStorage(String key) {
    storage.deleteItem(key);
  }

  static String isAfternoon(){
    final theHour = Moment.now().hour;
    if(theHour > 12 ) {
      return "afternoon";
    } else if(theHour < 12 ) return "morning";
    else return "evening";
  }
}
