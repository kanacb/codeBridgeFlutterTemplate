// RecentItemsHelper.dart
import 'dart:convert';
import '../../Utils/Services/SharedPreferences.dart';

const String recentItemsKey = 'recent_items';

// Retrieves the list of recent items from SharedPreferences.
Future<List<String>> getRecentItems() async {
  final jsonString = await getPref(recentItemsKey);
  if (jsonString == null) return [];
  try {
    final List<dynamic> jsonList = json.decode(jsonString);
    return List<String>.from(jsonList);
  } catch (e) {
    return [];
  }
}

// Records a page visit by adding the pageName to the list.
// It removes duplicates, inserts the new page at the beginning,
// and caps the list at three items.
Future<void> recordPageVisit(String pageName) async {
  List<String> items = await getRecentItems();
  items.remove(pageName); // Remove duplicate if exists.
  items.insert(0, pageName); // Insert new visit at the front.
  if (items.length > 3) {
    items = items.sublist(0, 3);
  }
  await savePref(recentItemsKey, json.encode(items));
}
