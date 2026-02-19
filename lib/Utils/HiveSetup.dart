import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../Widgets/Positions/Positions.dart';
import '../Widgets/Positions/PositionsProvider.dart';
import '../Widgets/Branches/Branches.dart';
import '../Widgets/Companies/Companies.dart';
import '../Widgets/Companies/CompanyProvider.dart';
import '../Widgets/Phones/Phone.dart';
import '../App/MenuBottomBar/Profile/ProfileProvider.dart';
import '../App/MenuBottomBar/Profile/Profile.dart';
import '../App/MenuBottomBar/Inbox/Inbox.dart';
import '../App/MenuBottomBar/Inbox/InboxProvider.dart';
import '../App/Dash/Notifications/CBNotification.dart';
import '../App/Dash/Notifications/NotificationProvider.dart';
import '../Widgets/Comments/CommentProvider.dart';
import '../Widgets/Comments/Comment.dart';
import '../Widgets/UserInvites/UserInvite.dart';
import '../Widgets/UserInvites/UserInviteProvider.dart';
import '../Widgets/DocumentsStorage/DocumentStorage.dart';
import '../Widgets/DocumentsStorage/DocumentStorageProvider.dart';
import '../Widgets/Users/User.dart';
import '../Widgets/Users/UserProvider.dart';
import 'Services/IdName.dart';
~cb-add-service-imports~
~cb-add-provider-imports~

class HiveSetup {
  static Future<void> initializeHive() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(InboxAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CommentAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(UserInviteAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(CBNotificationAdapter()); // 5
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(DocumentStorageAdapter());
    }
   
    if (!Hive.isAdapterRegistered(19)) {
      Hive.registerAdapter(IdNameAdapter());
    }
    if (!Hive.isAdapterRegistered(37)) {
      Hive.registerAdapter(BranchesAdapter());
    }
    if (!Hive.isAdapterRegistered(38)) {
      Hive.registerAdapter(CompaniesAdapter());
    }
    if (!Hive.isAdapterRegistered(56)) {
      Hive.registerAdapter(PositionsAdapter());
    }
    if (!Hive.isAdapterRegistered(57)) {
      Hive.registerAdapter(PhoneAdapter());
    }
    // ~cb-add-service-adapters~

    // Open required boxes
    if (!Hive.isBoxOpen('usersBox')) {
      await Hive.openBox<User>('usersBox');
    }
    if (!Hive.isBoxOpen('profilesBox')) {
      await Hive.openBox<Profile>('profilesBox');
    }
    if (!Hive.isBoxOpen('inboxesBox')) {
      await Hive.openBox<Inbox>('inboxesBox');
    }
    if (!Hive.isBoxOpen('commentsBox')) {
      await Hive.openBox<Comment>('commentsBox');
    }
    if (!Hive.isBoxOpen('userInvitesBox')) {
      await Hive.openBox<UserInvite>('userInvitesBox');
    }
    if (!Hive.isBoxOpen('notificationsBox')) {
      await Hive.openBox<CBNotification>('notificationsBox');
    }
    if (!Hive.isBoxOpen('documentsStorageBox')) {
      await Hive.openBox<DocumentStorage>('documentsStorageBox');
    }
    if (!Hive.isBoxOpen('BranchesBox')) {
      await Hive.openBox<Branches>('BranchesBox');
    }
    if (!Hive.isBoxOpen('CompaniesBox')) {
      await Hive.openBox<Companies>('CompaniesBox');
    }
    if (!Hive.isBoxOpen('positionsBox')) {
      await Hive.openBox<Positions>('positionsBox');
    }
     ~cb-add-hivebox~
  }

  List<SingleChildWidget> providers() {
    return [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => InboxProvider()),
      ChangeNotifierProvider(create: (_) => CommentProvider()),
      ChangeNotifierProvider(create: (_) => UserInviteProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => DocumentStorageProvider()),
      ChangeNotifierProvider(create: (_) => PositionsProvider()),
      // ~cb-add-notifier~
    ];
  }
}
