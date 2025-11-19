import 'dart:convert';

import 'package:intl/intl.dart';

import '../../Widgets/AtlasMachines/AtlasMachines.dart';
import '../App/MenuBottomBar/Profile/Profile.dart';
import '../App/MenuBottomBar/Profile/ProfileProvider.dart';
import '../Widgets/Companies/Companies.dart';
import '../Widgets/Companies/CompanyProvider.dart';
import '../Widgets/VendingMachine/VendingMachine.dart';
import '../Widgets/VendingMachine/VendingMachineProvider.dart';
import 'Services/SharedPreferences.dart';

class Methods {
  static Future<Profile?> loadSelectedProfile() async {
    var storedProfile = await getPref("selectedProfile");
    if (storedProfile != null) {
      try {
        final profiles = ProfileProvider().profiles;
        Profile profile = profiles.firstWhere((p) => p.id == storedProfile);
        // Print the profile JSON so you can see what was loaded.
        return profile;
      } catch (e) {
        print("DEBUG: Error parsing stored profile: $e");
        return null;
      }
    } else {
      print("DEBUG: No stored profile found.");
      return null;
    }
  }

  static Companies? getCompanyFromMachine(dynamic object) {
    final companies = CompanyProvider().data;

    try {
      final companyId = object.ownership.companyId.sId as String;
      return companies.firstWhere((i) => i.id == companyId);
    } catch (e) {
      print("Invalid object passed to getCompany: $e");
      return null;
    }
  }

  static Companies? getCompanyFromProfile(Profile profile) {
    final companies = CompanyProvider().data;
    return companies
        .where((i) => i.id == profile.company?.sId)
        .firstOrNull;
  }

  static VendingMachine getVM(AtlasMachines machine) {
    final vendingMachines = VendingMachineProvider().data;
    VendingMachine vm = vendingMachines
        .firstWhere((i) => i.id == machine.vendingMachineType?.sId);
    return vm;
  }

  static String encodeQueryParameters(Map<String, dynamic> params, [String prefix = '']) {
    List<String> pairs = [];

    params.forEach((key, value) {
      String newKey = prefix.isEmpty ? key : '$prefix[$key]';

      if (value is Map<String, dynamic>) {
        pairs.add(encodeQueryParameters(value, newKey));
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          var item = value[i];
          if (item is Map<String, dynamic>) {
            pairs.add(encodeQueryParameters(item, '$newKey[$i]'));
          } else {
            pairs.add('${Uri.encodeQueryComponent('$newKey[$i]')}=${Uri.encodeQueryComponent(item.toString())}');
          }
        }
      } else {
        pairs.add('${Uri.encodeQueryComponent(newKey)}=${Uri.encodeQueryComponent(value.toString())}');
      }
    });

    return pairs.join('&');
  }

  static String formatDateTime(DateTime? dateTimeUtc, {String fallback = "Not Started"}) {
    if(dateTimeUtc == null) return fallback;
    final dateTime = dateTimeUtc.toLocal();
    return DateFormat("dd/MM/yyyy, HH:mm:ss").format(dateTime);
  }

  static String cleanQuery(String url) {
    return url
        .replaceAll('\n', '')       // Remove newline characters
        .replaceAll('\r', '')       // Remove carriage return (for Windows-style newlines)
        .replaceAll(' ', '')        // Remove spaces
        .trim();                    // Trim leading/trailing whitespace
  }
}
