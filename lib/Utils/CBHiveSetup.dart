import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../CBWidgets/Users/User.dart';
import '../CBWidgets/Companies/Company.dart';
import '../CBWidgets/Branches/Branch.dart';
import '../CBWidgets/Departments/Department.dart';
import '../CBWidgets/Sections/Section.dart';
import '../CBWidgets/Roles/Role.dart';
import '../CBWidgets/Positions/Position.dart';
import '../CBWidgets/Profiles/Profile.dart';
import '../CBWidgets/Templates/Template.dart';
import '../CBWidgets/UserAddresses/UserAddress.dart';
import '../CBWidgets/CompanyAddresses/CompanyAddress.dart';
import '../CBWidgets/CompanyPhones/CompanyPhone.dart';
import '../CBWidgets/UserPhones/UserPhone.dart';
import '../CBWidgets/Staffinfo/Staffinfo.dart';
import '../CBWidgets/Employees/Employee.dart';
import '../CBWidgets/Superiors/Superior.dart';
import '../CBWidgets/DepartmentAdmin/DepartmentAdmin.dart';
import '../CBWidgets/DepartmentHOD/DepartmentHOD.dart';
import '../CBWidgets/DepartmentHOS/DepartmentHO.dart';
import '../CBWidgets/UserGuideSteps/UserGuideStep.dart';
import '../CBWidgets/UserGuide/UserGuide.dart';
import '../CBWidgets/Audits/Audit.dart';
import '../CBWidgets/ChataiEnabler/ChataiEnabler.dart';
import '../CBWidgets/ChataiConfig/ChataiConfig.dart';
import '../CBWidgets/ChataiPrompts/ChataiPrompt.dart';
import '../CBWidgets/DocumentStorages/DocumentStorage.dart';
import '../CBWidgets/Fcms/Fcm.dart';
import '../CBWidgets/FcmQues/FcmQue.dart';
import '../CBWidgets/FcmMessages/FcmMessage.dart';
import '../CBWidgets/HelpSidebarContents/HelpSidebarContent.dart';
import '../CBWidgets/LoginHistories/LoginHistory.dart';
import '../CBWidgets/MailQues/MailQue.dart';
import '../CBWidgets/ProfileMenu/ProfileMenu.dart';
import '../CBWidgets/MenuItems/MenuItem.dart';
import '../CBWidgets/Uploader/Uploader.dart';
import '../CBWidgets/UserChangePassword/UserChangePassword.dart';
import '../CBWidgets/UserInvites/UserInvite.dart';
import '../CBWidgets/UserTrackerId/UserTrackerId.dart';
import '../CBWidgets/PermissionServices/PermissionService.dart';
import '../CBWidgets/PermissionFields/PermissionField.dart';
import '../CBWidgets/ErrorLogs/ErrorLog.dart';
import '../CBWidgets/Inbox/Inbox.dart';
// ~cb-add-service-imports~

import '../CBWidgets/Users/UsersProvider.dart';
import '../CBWidgets/Companies/CompaniesProvider.dart';
import '../CBWidgets/Branches/BranchesProvider.dart';
import '../CBWidgets/Departments/DepartmentsProvider.dart';
import '../CBWidgets/Sections/SectionsProvider.dart';
import '../CBWidgets/Roles/RolesProvider.dart';
import '../CBWidgets/Positions/PositionsProvider.dart';
import '../CBWidgets/Profiles/ProfilesProvider.dart';
import '../CBWidgets/Templates/TemplatesProvider.dart';
import '../CBWidgets/UserAddresses/UserAddressesProvider.dart';
import '../CBWidgets/CompanyAddresses/CompanyAddressesProvider.dart';
import '../CBWidgets/CompanyPhones/CompanyPhonesProvider.dart';
import '../CBWidgets/UserPhones/UserPhonesProvider.dart';
import '../CBWidgets/Staffinfo/StaffinfoProvider.dart';
import '../CBWidgets/Employees/EmployeesProvider.dart';
import '../CBWidgets/Superiors/SuperiorsProvider.dart';
import '../CBWidgets/DepartmentAdmin/DepartmentAdminProvider.dart';
import '../CBWidgets/DepartmentHOD/DepartmentHODProvider.dart';
import '../CBWidgets/DepartmentHOS/DepartmentHOSProvider.dart';
import '../CBWidgets/UserGuideSteps/UserGuideStepsProvider.dart';
import '../CBWidgets/UserGuide/UserGuideProvider.dart';
import '../CBWidgets/Audits/AuditsProvider.dart';
import '../CBWidgets/ChataiEnabler/ChataiEnablerProvider.dart';
import '../CBWidgets/ChataiConfig/ChataiConfigProvider.dart';
import '../CBWidgets/ChataiPrompts/ChataiPromptsProvider.dart';
import '../CBWidgets/DocumentStorages/DocumentStoragesProvider.dart';
import '../CBWidgets/Fcms/FcmsProvider.dart';
import '../CBWidgets/FcmQues/FcmQuesProvider.dart';
import '../CBWidgets/FcmMessages/FcmMessagesProvider.dart';
import '../CBWidgets/HelpSidebarContents/HelpSidebarContentsProvider.dart';
import '../CBWidgets/LoginHistories/LoginHistoriesProvider.dart';
import '../CBWidgets/MailQues/MailQuesProvider.dart';
import '../CBWidgets/ProfileMenu/ProfileMenuProvider.dart';
import '../CBWidgets/MenuItems/MenuItemsProvider.dart';
import '../CBWidgets/Uploader/UploaderProvider.dart';
import '../CBWidgets/UserChangePassword/UserChangePasswordProvider.dart';
import '../CBWidgets/UserInvites/UserInvitesProvider.dart';
import '../CBWidgets/UserTrackerId/UserTrackerIdProvider.dart';
import '../CBWidgets/PermissionServices/PermissionServicesProvider.dart';
import '../CBWidgets/PermissionFields/PermissionFieldsProvider.dart';
import '../CBWidgets/ErrorLogs/ErrorLogsProvider.dart';
import '../CBWidgets/Inbox/InboxProvider.dart';
// ~cb-add-provider-imports~

class CBHiveSetup {
  static Future<void> initializeHive() async {
    // Initialize Hive
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(CompanyAdapter());
    }

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(BranchAdapter());
    }

    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(DepartmentAdapter());
    }

    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(SectionAdapter());
    }

    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(RoleAdapter());
    }

    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(PositionAdapter());
    }

    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(ProfileAdapter());
    }

    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(TemplateAdapter());
    }

    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(UserAddressAdapter());
    }

    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(CompanyAddressAdapter());
    }

    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(CompanyPhoneAdapter());
    }

    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(UserPhoneAdapter());
    }

    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(StaffinfoAdapter());
    }

    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(EmployeeAdapter());
    }

    if (!Hive.isAdapterRegistered(16)) {
      Hive.registerAdapter(SuperiorAdapter());
    }

    if (!Hive.isAdapterRegistered(17)) {
      Hive.registerAdapter(DepartmentAdminAdapter());
    }

    if (!Hive.isAdapterRegistered(18)) {
      Hive.registerAdapter(DepartmentHODAdapter());
    }

    if (!Hive.isAdapterRegistered(19)) {
      Hive.registerAdapter(DepartmentHOAdapter());
    }

    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(UserGuideStepAdapter());
    }

    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(UserGuideAdapter());
    }

    if (!Hive.isAdapterRegistered(22)) {
      Hive.registerAdapter(AuditAdapter());
    }

    if (!Hive.isAdapterRegistered(23)) {
      Hive.registerAdapter(ChataiEnablerAdapter());
    }

    if (!Hive.isAdapterRegistered(24)) {
      Hive.registerAdapter(ChataiConfigAdapter());
    }

    if (!Hive.isAdapterRegistered(25)) {
      Hive.registerAdapter(ChataiPromptAdapter());
    }

    if (!Hive.isAdapterRegistered(26)) {
      Hive.registerAdapter(DocumentStorageAdapter());
    }

    if (!Hive.isAdapterRegistered(27)) {
      Hive.registerAdapter(FcmAdapter());
    }

    if (!Hive.isAdapterRegistered(28)) {
      Hive.registerAdapter(FcmQueAdapter());
    }

    if (!Hive.isAdapterRegistered(29)) {
      Hive.registerAdapter(FcmMessageAdapter());
    }

    if (!Hive.isAdapterRegistered(30)) {
      Hive.registerAdapter(HelpBarContentAdapter());
    }

    if (!Hive.isAdapterRegistered(31)) {
      Hive.registerAdapter(LoginHistoryAdapter());
    }

    if (!Hive.isAdapterRegistered(32)) {
      Hive.registerAdapter(MailQueAdapter());
    }

    if (!Hive.isAdapterRegistered(33)) {
      Hive.registerAdapter(ProfileMenuAdapter());
    }

    if (!Hive.isAdapterRegistered(34)) {
      Hive.registerAdapter(MenuItemAdapter());
    }

    if (!Hive.isAdapterRegistered(35)) {
      Hive.registerAdapter(UploaderAdapter());
    }

    if (!Hive.isAdapterRegistered(36)) {
      Hive.registerAdapter(UserChangePasswordAdapter());
    }

    if (!Hive.isAdapterRegistered(37)) {
      Hive.registerAdapter(UserInviteAdapter());
    }

    if (!Hive.isAdapterRegistered(38)) {
      Hive.registerAdapter(UserTrackerIdAdapter());
    }

    if (!Hive.isAdapterRegistered(39)) {
      Hive.registerAdapter(PermissionServiceAdapter());
    }

    if (!Hive.isAdapterRegistered(40)) {
      Hive.registerAdapter(PermissionFieldAdapter());
    }

    // ~cb-add-service-adapters~

    if (!Hive.isBoxOpen('usersBox')) {
      await Hive.openBox<User>('usersBox');
    }

    if (!Hive.isBoxOpen('companiesBox')) {
      await Hive.openBox<User>('companiesBox');
    }

    if (!Hive.isBoxOpen('branchesBox')) {
      await Hive.openBox<User>('branchesBox');
    }

    if (!Hive.isBoxOpen('departmentsBox')) {
      await Hive.openBox<User>('departmentsBox');
    }

    if (!Hive.isBoxOpen('sectionsBox')) {
      await Hive.openBox<User>('sectionsBox');
    }

    if (!Hive.isBoxOpen('rolesBox')) {
      await Hive.openBox<User>('rolesBox');
    }

    if (!Hive.isBoxOpen('positionsBox')) {
      await Hive.openBox<User>('positionsBox');
    }

    if (!Hive.isBoxOpen('profilesBox')) {
      await Hive.openBox<User>('profilesBox');
    }

    if (!Hive.isBoxOpen('templatesBox')) {
      await Hive.openBox<User>('templatesBox');
    }

    if (!Hive.isBoxOpen('userAddressesBox')) {
      await Hive.openBox<User>('userAddressesBox');
    }

    if (!Hive.isBoxOpen('companyAddressesBox')) {
      await Hive.openBox<User>('companyAddressesBox');
    }

    if (!Hive.isBoxOpen('companyPhonesBox')) {
      await Hive.openBox<User>('companyPhonesBox');
    }

    if (!Hive.isBoxOpen('userPhonesBox')) {
      await Hive.openBox<User>('userPhonesBox');
    }

    if (!Hive.isBoxOpen('staffinfoBox')) {
      await Hive.openBox<User>('staffinfoBox');
    }

    if (!Hive.isBoxOpen('employeesBox')) {
      await Hive.openBox<User>('employeesBox');
    }

    if (!Hive.isBoxOpen('superiorBox')) {
      await Hive.openBox<User>('superiorBox');
    }

    if (!Hive.isBoxOpen('departmentAdminBox')) {
      await Hive.openBox<User>('departmentAdminBox');
    }

    if (!Hive.isBoxOpen('departmentHODBox')) {
      await Hive.openBox<User>('departmentHODBox');
    }

    if (!Hive.isBoxOpen('departmentHOSBox')) {
      await Hive.openBox<User>('departmentHOSBox');
    }

    if (!Hive.isBoxOpen('userGuideStepsBox')) {
      await Hive.openBox<User>('userGuideStepsBox');
    }

    if (!Hive.isBoxOpen('userGuideBox')) {
      await Hive.openBox<User>('userGuideBox');
    }

    if (!Hive.isBoxOpen('auditsBox')) {
      await Hive.openBox<User>('auditsBox');
    }

    if (!Hive.isBoxOpen('chataiEnablerBox')) {
      await Hive.openBox<User>('chataiEnablerBox');
    }

    if (!Hive.isBoxOpen('chataiConfigBox')) {
      await Hive.openBox<User>('chataiConfigBox');
    }

    if (!Hive.isBoxOpen('chataiPromptsBox')) {
      await Hive.openBox<User>('chataiPromptsBox');
    }

    if (!Hive.isBoxOpen('documentStorageBox')) {
      await Hive.openBox<User>('documentStorageBox');
    }

    if (!Hive.isBoxOpen('fcmsBox')) {
      await Hive.openBox<User>('fcmsBox');
    }

    if (!Hive.isBoxOpen('fcmQuesBox')) {
      await Hive.openBox<User>('fcmQuesBox');
    }

    if (!Hive.isBoxOpen('fcmMessagesBox')) {
      await Hive.openBox<User>('fcmMessagesBox');
    }

    if (!Hive.isBoxOpen('helpBarContentsBox')) {
      await Hive.openBox<User>('helpBarContentsBox');
    }

    if (!Hive.isBoxOpen('loginHistoriesBox')) {
      await Hive.openBox<User>('loginHistoriesBox');
    }

    if (!Hive.isBoxOpen('mailQuesBox')) {
      await Hive.openBox<User>('mailQuesBox');
    }

    if (!Hive.isBoxOpen('profileMenuBox')) {
      await Hive.openBox<User>('profileMenuBox');
    }

    if (!Hive.isBoxOpen('menuItemsBox')) {
      await Hive.openBox<User>('menuItemsBox');
    }

    if (!Hive.isBoxOpen('uploaderBox')) {
      await Hive.openBox<User>('uploaderBox');
    }

    if (!Hive.isBoxOpen('userChangePasswordBox')) {
      await Hive.openBox<User>('userChangePasswordBox');
    }

    if (!Hive.isBoxOpen('userInvitesBox')) {
      await Hive.openBox<User>('userInvitesBox');
    }

    if (!Hive.isBoxOpen('userTrackerIdBox')) {
      await Hive.openBox<User>('userTrackerIdBox');
    }

    if (!Hive.isBoxOpen('permissionServicesBox')) {
      await Hive.openBox<User>('permissionServicesBox');
    }

    if (!Hive.isBoxOpen('permissionFieldsBox')) {
      await Hive.openBox<User>('permissionFieldsBox');
    }

    // ~cb-add-hivebox~
  }

  List<SingleChildWidget> providers() {
    return [
      ChangeNotifierProvider(create: (_) => UsersProvider()),
      ChangeNotifierProvider(create: (_) => CompaniesProvider()),
      ChangeNotifierProvider(create: (_) => BranchesProvider()),
      ChangeNotifierProvider(create: (_) => DepartmentsProvider()),
      ChangeNotifierProvider(create: (_) => SectionsProvider()),
      ChangeNotifierProvider(create: (_) => RolesProvider()),
      ChangeNotifierProvider(create: (_) => PositionsProvider()),
      ChangeNotifierProvider(create: (_) => ProfilesProvider()),
      ChangeNotifierProvider(create: (_) => TemplatesProvider()),
      ChangeNotifierProvider(create: (_) => UserAddressesProvider()),
      ChangeNotifierProvider(create: (_) => CompanyAddressesProvider()),
      ChangeNotifierProvider(create: (_) => CompanyPhonesProvider()),
      ChangeNotifierProvider(create: (_) => UserPhonesProvider()),
      ChangeNotifierProvider(create: (_) => StaffinfoProvider()),
      ChangeNotifierProvider(create: (_) => EmployeesProvider()),
      ChangeNotifierProvider(create: (_) => SuperiorProvider()),
      ChangeNotifierProvider(create: (_) => DepartmentAdminProvider()),
      ChangeNotifierProvider(create: (_) => DepartmentHODProvider()),
      ChangeNotifierProvider(create: (_) => DepartmentHOSProvider()),
      ChangeNotifierProvider(create: (_) => UserGuideStepsProvider()),
      ChangeNotifierProvider(create: (_) => UserGuideProvider()),
      ChangeNotifierProvider(create: (_) => AuditsProvider()),
      ChangeNotifierProvider(create: (_) => ChataiEnablerProvider()),
      ChangeNotifierProvider(create: (_) => ChataiConfigProvider()),
      ChangeNotifierProvider(create: (_) => ChataiPromptsProvider()),
      ChangeNotifierProvider(create: (_) => DocumentStorageProvider()),
      ChangeNotifierProvider(create: (_) => FcmsProvider()),
      ChangeNotifierProvider(create: (_) => FcmQuesProvider()),
      ChangeNotifierProvider(create: (_) => FcmMessagesProvider()),
      ChangeNotifierProvider(create: (_) => HelpBarContentsProvider()),
      ChangeNotifierProvider(create: (_) => LoginHistoriesProvider()),
      ChangeNotifierProvider(create: (_) => MailQuesProvider()),
      ChangeNotifierProvider(create: (_) => ProfileMenuProvider()),
      ChangeNotifierProvider(create: (_) => MenuItemsProvider()),
      ChangeNotifierProvider(create: (_) => UploaderProvider()),
      ChangeNotifierProvider(create: (_) => UserChangePasswordProvider()),
      ChangeNotifierProvider(create: (_) => UserInvitesProvider()),
      ChangeNotifierProvider(create: (_) => UserTrackerIdProvider()),
      ChangeNotifierProvider(create: (_) => PermissionServicesProvider()),
      ChangeNotifierProvider(create: (_) => PermissionFieldsProvider()),
      // ~cb-add-notifier~
    ];
  }
}
