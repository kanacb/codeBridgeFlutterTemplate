import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../App/MenuBottomBar/Profile/ProfileProvider.dart';
import '../App/MenuBottomBar/Profile/Profile.dart';
import '../App/MenuBottomBar/Inbox/Inbox.dart';
import '../App/MenuBottomBar/Inbox/InboxProvider.dart';
import '../App/Dash/Notifications/CBNotification.dart';
import '../App/Dash/Notifications/NotificationProvider.dart';
import '../CBWidgets/Profiles/Profile.dart';
import '../CBWidgets/Profiles/ProfilesProvider.dart';
import '../CBWidgets/DocumentsStorage/DocumentStorage.dart';
import '../CBWidgets/DocumentsStorage/DocumentStorageProvider.dart';
import '../CBWidgets/Comments/Comment.dart';
import '../CBWidgets/Comments/CommentProvider.dart';
import './Services/IdName.dart';
import '../CBWidgets/Users/Users.dart';
import '../CBWidgets/Companies/Companies.dart';
import '../CBWidgets/Branches/Branches.dart';
import '../CBWidgets/Departments/Departments.dart';
import '../CBWidgets/Sections/Sections.dart';
import '../CBWidgets/Roles/Roles.dart';
import '../CBWidgets/Positions/Positions.dart';
import '../CBWidgets/Profiles/Profiles.dart';
import '../CBWidgets/Templates/Templates.dart';
import '../CBWidgets/Tests/Tests.dart';
import '../CBWidgets/UserAddresses/UserAddresses.dart';
import '../CBWidgets/CompanyAddresses/CompanyAddresses.dart';
import '../CBWidgets/CompanyPhones/CompanyPhones.dart';
import '../CBWidgets/UserPhones/UserPhones.dart';
import '../CBWidgets/Staffinfo/Staffinfo.dart';
import '../CBWidgets/Employees/Employees.dart';
import '../CBWidgets/Superior/Superior.dart';
import '../CBWidgets/DepartmentAdmin/DepartmentAdmin.dart';
import '../CBWidgets/DepartmentHOD/DepartmentHOD.dart';
import '../CBWidgets/DepartmentHOS/DepartmentHOS.dart';
import '../CBWidgets/Steps/Steps.dart';
import '../CBWidgets/UserGuide/UserGuide.dart';
import '../CBWidgets/Users/UsersProvider.dart';
import '../CBWidgets/Companies/CompaniesProvider.dart';
import '../CBWidgets/Branches/BranchesProvider.dart';
import '../CBWidgets/Departments/DepartmentsProvider.dart';
import '../CBWidgets/Sections/SectionsProvider.dart';
import '../CBWidgets/Roles/RolesProvider.dart';
import '../CBWidgets/Positions/PositionsProvider.dart';
import '../CBWidgets/Profiles/ProfilesProvider.dart';
import '../CBWidgets/Templates/TemplatesProvider.dart';
import '../CBWidgets/Tests/TestsProvider.dart';
import '../CBWidgets/UserAddresses/UserAddressesProvider.dart';
import '../CBWidgets/CompanyAddresses/CompanyAddressesProvider.dart';
import '../CBWidgets/CompanyPhones/CompanyPhonesProvider.dart';
import '../CBWidgets/UserPhones/UserPhonesProvider.dart';
import '../CBWidgets/Staffinfo/StaffinfoProvider.dart';
import '../CBWidgets/Employees/EmployeesProvider.dart';
import '../CBWidgets/Superior/SuperiorProvider.dart';
import '../CBWidgets/DepartmentAdmin/DepartmentAdminProvider.dart';
import '../CBWidgets/DepartmentHOD/DepartmentHODProvider.dart';
import '../CBWidgets/DepartmentHOS/DepartmentHOSProvider.dart';
import '../CBWidgets/Steps/StepsProvider.dart';
import '../CBWidgets/UserGuide/UserGuideProvider.dart';

// ~cb-add-service-imports~

// ~cb-add-provider-imports~

class HiveSetup {
  static Future<void> initializeHive() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters

    if (!Hive.isAdapterRegistered(23)) {
      Hive.registerAdapter(ProfilesAdapter());
    }

    if (!Hive.isAdapterRegistered(24)) {
      Hive.registerAdapter(InboxAdapter());
    }

    if (!Hive.isAdapterRegistered(25)) {
      Hive.registerAdapter(CommentsAdapter());
    }

    if (!Hive.isAdapterRegistered(26)) {
      Hive.registerAdapter(CBNotificationAdapter());
    }

    if (!Hive.isAdapterRegistered(27)) {
      Hive.registerAdapter(DocumentStorageAdapter());
    }

    // Open required boxes
    if (!Hive.isBoxOpen('profilesBox')) {
      await Hive.openBox<Profile>('profilesBox');
    }
    if (!Hive.isBoxOpen('inboxesBox')) {
      await Hive.openBox<Inbox>('inboxesBox');
    }
    if (!Hive.isBoxOpen('commentsBox')) {
      await Hive.openBox<Comment>('commentsBox');
    }
    if (!Hive.isBoxOpen('notificationsBox')) {
      await Hive.openBox<CBNotification>('notificationsBox');
    }
    if (!Hive.isBoxOpen('documentsStorageBox')) {
      await Hive.openBox<DocumentStorage>('documentsStorageBox');
    }

    // ~cb-add-service-adapters~

    // ~cb-add-hivebox~
  }

  List<SingleChildWidget> providers() {
    return [
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => InboxProvider()),
      ChangeNotifierProvider(create: (_) => CommentProvider()),
      ChangeNotifierProvider(create: (_) => UserInviteProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => DocumentStorageProvider()),

      // ~cb-add-notifier~
    ];
  }
}
