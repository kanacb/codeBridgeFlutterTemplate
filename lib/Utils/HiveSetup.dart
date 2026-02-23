import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../CBWidgets/Profiles/ProfilesProvider.dart';
import '../CBWidgets/Profiles/Profile.dart';
import '../App/MenuBottomBar/Inbox/Inbox.dart';
import '../App/MenuBottomBar/Inbox/InboxProvider.dart';
import '../App/Dash/Notifications/CBNotification.dart';
import '../App/Dash/Notifications/NotificationProvider.dart';
import './Services/IdName.dart';

// ~cb-add-service-imports~

// ~cb-add-provider-imports~

class HiveSetup {
  static Future<void> initializeHive() async {
    // Initialize Hive
    await Hive.initFlutter();

    // ~cb-add-service-adapters~

    // ~cb-add-hivebox~
  }

  List<SingleChildWidget> providers() {
    return [
      // ~cb-add-notifier~
    ];
  }
}
