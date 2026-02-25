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

import '../Widgets/Users/User.dart';
import '../Widgets/Companies/Company.dart';
import '../Widgets/Branches/Branch.dart';
import '../Widgets/Departments/Department.dart';
import '../Widgets/Sections/Section.dart';
import '../Widgets/Roles/Role.dart';
import '../Widgets/Positions/Position.dart';
import '../Widgets/Profiles/Profile.dart';
import '../Widgets/Templates/Template.dart';
import '../Widgets/UserAddresses/UserAddress.dart';
import '../Widgets/CompanyAddresses/CompanyAddress.dart';
import '../Widgets/CompanyPhones/CompanyPhone.dart';
import '../Widgets/UserPhones/UserPhone.dart';
import '../Widgets/Staffinfo/Staffinfo.dart';
import '../Widgets/Employees/Employee.dart';
import '../Widgets/Superiors/Superior.dart';
import '../Widgets/DepartmentAdmin/DepartmentAdmin.dart';
import '../Widgets/DepartmentHOD/DepartmentHOD.dart';
import '../Widgets/DepartmentHOS/DepartmentHO.dart';
import '../Widgets/UserGuideSteps/UserGuideStep.dart';
import '../Widgets/UserGuide/UserGuide.dart';
import '../Widgets/Audits/Audit.dart';
import '../Widgets/ChataiEnabler/ChataiEnabler.dart';
import '../Widgets/ChataiConfig/ChataiConfig.dart';
import '../Widgets/ChataiPrompts/ChataiPrompt.dart';
import '../Widgets/DocumentStorages/DocumentStorage.dart';
import '../Widgets/Fcms/Fcm.dart';
import '../Widgets/FcmQues/FcmQue.dart';
import '../Widgets/FcmMessages/FcmMessage.dart';
import '../Widgets/HelpSidebarContents/HelpSidebarContent.dart';
import '../Widgets/LoginHistories/LoginHistory.dart';
import '../Widgets/MailQues/MailQue.dart';
import '../Widgets/ProfileMenu/ProfileMenu.dart';
import '../Widgets/MenuItems/MenuItem.dart';
import '../Widgets/Uploader/Uploader.dart';
import '../Widgets/UserChangePassword/UserChangePassword.dart';
import '../Widgets/UserInvites/UserInvite.dart';
import '../Widgets/UserTrackerId/UserTrackerId.dart';
import '../Widgets/PermissionServices/PermissionService.dart';
import '../Widgets/PermissionFields/PermissionField.dart';
import '../Widgets/ErrorLogs/ErrorLog.dart';
import '../Widgets/Inbox/Inbox.dart';
// ~cb-add-service-imports~

import '../Widgets/Users/UsersProvider.dart';
import '../Widgets/Companies/CompaniesProvider.dart';
import '../Widgets/Branches/BranchesProvider.dart';
import '../Widgets/Departments/DepartmentsProvider.dart';
import '../Widgets/Sections/SectionsProvider.dart';
import '../Widgets/Roles/RolesProvider.dart';
import '../Widgets/Positions/PositionsProvider.dart';
import '../Widgets/Profiles/ProfilesProvider.dart';
import '../Widgets/Templates/TemplatesProvider.dart';
import '../Widgets/UserAddresses/UserAddressesProvider.dart';
import '../Widgets/CompanyAddresses/CompanyAddressesProvider.dart';
import '../Widgets/CompanyPhones/CompanyPhonesProvider.dart';
import '../Widgets/UserPhones/UserPhonesProvider.dart';
import '../Widgets/Staffinfo/StaffinfoProvider.dart';
import '../Widgets/Employees/EmployeesProvider.dart';
import '../Widgets/Superiors/SuperiorsProvider.dart';
import '../Widgets/DepartmentAdmin/DepartmentAdminProvider.dart';
import '../Widgets/DepartmentHOD/DepartmentHODProvider.dart';
import '../Widgets/DepartmentHOS/DepartmentHOSProvider.dart';
import '../Widgets/UserGuideSteps/UserGuideStepsProvider.dart';
import '../Widgets/UserGuide/UserGuideProvider.dart';
import '../Widgets/Audits/AuditsProvider.dart';
import '../Widgets/ChataiEnabler/ChataiEnablerProvider.dart';
import '../Widgets/ChataiConfig/ChataiConfigProvider.dart';
import '../Widgets/ChataiPrompts/ChataiPromptsProvider.dart';
import '../Widgets/DocumentStorages/DocumentStoragesProvider.dart';
import '../Widgets/Fcms/FcmsProvider.dart';
import '../Widgets/FcmQues/FcmQuesProvider.dart';
import '../Widgets/FcmMessages/FcmMessagesProvider.dart';
import '../Widgets/HelpSidebarContents/HelpSidebarContentsProvider.dart';
import '../Widgets/LoginHistories/LoginHistoriesProvider.dart';
import '../Widgets/MailQues/MailQuesProvider.dart';
import '../Widgets/ProfileMenu/ProfileMenuProvider.dart';
import '../Widgets/MenuItems/MenuItemsProvider.dart';
import '../Widgets/Uploader/UploaderProvider.dart';
import '../Widgets/UserChangePassword/UserChangePasswordProvider.dart';
import '../Widgets/UserInvites/UserInvitesProvider.dart';
import '../Widgets/UserTrackerId/UserTrackerIdProvider.dart';
import '../Widgets/PermissionServices/PermissionServicesProvider.dart';
import '../Widgets/PermissionFields/PermissionFieldsProvider.dart';
import '../Widgets/ErrorLogs/ErrorLogsProvider.dart';
import '../Widgets/Inbox/InboxProvider.dart';
// ~cb-add-provider-imports~

class HiveSetup {
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
      Hive.registerAdapter(HelpSidebarContentAdapter());
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

    if (!Hive.isAdapterRegistered(41)) {
      Hive.registerAdapter(ErrorLogAdapter());
    }

    if (!Hive.isAdapterRegistered(42)) {
      Hive.registerAdapter(InboxAdapter());
    }

    // ~cb-add-service-adapters~

    if (!Hive.isBoxOpen('usersBox')) {
      await Hive.openBox<User>('usersBox');
    }

    if (!Hive.isBoxOpen('companiesBox')) {
      await Hive.openBox<Company>('companiesBox');
    }

    if (!Hive.isBoxOpen('branchesBox')) {
      await Hive.openBox<Branch>('branchesBox');
    }

    if (!Hive.isBoxOpen('departmentsBox')) {
      await Hive.openBox<Department>('departmentsBox');
    }

    if (!Hive.isBoxOpen('sectionsBox')) {
      await Hive.openBox<Section>('sectionsBox');
    }

    if (!Hive.isBoxOpen('rolesBox')) {
      await Hive.openBox<Role>('rolesBox');
    }

    if (!Hive.isBoxOpen('positionsBox')) {
      await Hive.openBox<Position>('positionsBox');
    }

    if (!Hive.isBoxOpen('profilesBox')) {
      await Hive.openBox<Profile>('profilesBox');
    }

    if (!Hive.isBoxOpen('templatesBox')) {
      await Hive.openBox<Template>('templatesBox');
    }

    if (!Hive.isBoxOpen('userAddressesBox')) {
      await Hive.openBox<UserAddress>('userAddressesBox');
    }

    if (!Hive.isBoxOpen('companyAddressesBox')) {
      await Hive.openBox<CompanyAddress>('companyAddressesBox');
    }

    if (!Hive.isBoxOpen('companyPhonesBox')) {
      await Hive.openBox<CompanyPhone>('companyPhonesBox');
    }

    if (!Hive.isBoxOpen('userPhonesBox')) {
      await Hive.openBox<UserPhone>('userPhonesBox');
    }

    if (!Hive.isBoxOpen('staffinfoBox')) {
      await Hive.openBox<Staffinfo>('staffinfoBox');
    }

    if (!Hive.isBoxOpen('employeesBox')) {
      await Hive.openBox<Employee>('employeesBox');
    }

    if (!Hive.isBoxOpen('superiorsBox')) {
      await Hive.openBox<Superior>('superiorsBox');
    }

    if (!Hive.isBoxOpen('departmentAdminBox')) {
      await Hive.openBox<DepartmentAdmin>('departmentAdminBox');
    }

    if (!Hive.isBoxOpen('departmentHODBox')) {
      await Hive.openBox<DepartmentHOD>('departmentHODBox');
    }

    if (!Hive.isBoxOpen('departmentHOSBox')) {
      await Hive.openBox<DepartmentHO>('departmentHOSBox');
    }

    if (!Hive.isBoxOpen('userGuideStepsBox')) {
      await Hive.openBox<UserGuideStep>('userGuideStepsBox');
    }

    if (!Hive.isBoxOpen('userGuideBox')) {
      await Hive.openBox<UserGuide>('userGuideBox');
    }

    if (!Hive.isBoxOpen('auditsBox')) {
      await Hive.openBox<Audit>('auditsBox');
    }

    if (!Hive.isBoxOpen('chataiEnablerBox')) {
      await Hive.openBox<ChataiEnabler>('chataiEnablerBox');
    }

    if (!Hive.isBoxOpen('chataiConfigBox')) {
      await Hive.openBox<ChataiConfig>('chataiConfigBox');
    }

    if (!Hive.isBoxOpen('chataiPromptsBox')) {
      await Hive.openBox<ChataiPrompt>('chataiPromptsBox');
    }

    if (!Hive.isBoxOpen('documentStoragesBox')) {
      await Hive.openBox<DocumentStorage>('documentStoragesBox');
    }

    if (!Hive.isBoxOpen('fcmsBox')) {
      await Hive.openBox<Fcm>('fcmsBox');
    }

    if (!Hive.isBoxOpen('fcmQuesBox')) {
      await Hive.openBox<FcmQue>('fcmQuesBox');
    }

    if (!Hive.isBoxOpen('fcmMessagesBox')) {
      await Hive.openBox<FcmMessage>('fcmMessagesBox');
    }

    if (!Hive.isBoxOpen('helpSidebarContentsBox')) {
      await Hive.openBox<HelpSidebarContent>('helpSidebarContentsBox');
    }

    if (!Hive.isBoxOpen('loginHistoriesBox')) {
      await Hive.openBox<LoginHistory>('loginHistoriesBox');
    }

    if (!Hive.isBoxOpen('mailQuesBox')) {
      await Hive.openBox<MailQue>('mailQuesBox');
    }

    if (!Hive.isBoxOpen('profileMenuBox')) {
      await Hive.openBox<ProfileMenu>('profileMenuBox');
    }

    if (!Hive.isBoxOpen('menuItemsBox')) {
      await Hive.openBox<MenuItem>('menuItemsBox');
    }

    if (!Hive.isBoxOpen('uploaderBox')) {
      await Hive.openBox<Uploader>('uploaderBox');
    }

    if (!Hive.isBoxOpen('userChangePasswordBox')) {
      await Hive.openBox<UserChangePassword>('userChangePasswordBox');
    }

    if (!Hive.isBoxOpen('userInvitesBox')) {
      await Hive.openBox<UserInvite>('userInvitesBox');
    }

    if (!Hive.isBoxOpen('userTrackerIdBox')) {
      await Hive.openBox<UserTrackerId>('userTrackerIdBox');
    }

    if (!Hive.isBoxOpen('permissionServicesBox')) {
      await Hive.openBox<PermissionService>('permissionServicesBox');
    }

    if (!Hive.isBoxOpen('permissionFieldsBox')) {
      await Hive.openBox<PermissionField>('permissionFieldsBox');
    }

    if (!Hive.isBoxOpen('errorLogsBox')) {
      await Hive.openBox<ErrorLog>('errorLogsBox');
    }

    if (!Hive.isBoxOpen('inboxBox')) {
      await Hive.openBox<Inbox>('inboxBox');
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
      ChangeNotifierProvider(create: (_) => SuperiorsProvider()),
      ChangeNotifierProvider(create: (_) => DepartmentAdminProvider()),
      ChangeNotifierProvider(create: (_) => DepartmentHODProvider()),
      ChangeNotifierProvider(create: (_) => DepartmentHOSProvider()),
      ChangeNotifierProvider(create: (_) => UserGuideStepsProvider()),
      ChangeNotifierProvider(create: (_) => UserGuideProvider()),
      ChangeNotifierProvider(create: (_) => AuditsProvider()),
      ChangeNotifierProvider(create: (_) => ChataiEnablerProvider()),
      ChangeNotifierProvider(create: (_) => ChataiConfigProvider()),
      ChangeNotifierProvider(create: (_) => ChataiPromptsProvider()),
      ChangeNotifierProvider(create: (_) => DocumentStoragesProvider()),
      ChangeNotifierProvider(create: (_) => FcmsProvider()),
      ChangeNotifierProvider(create: (_) => FcmQuesProvider()),
      ChangeNotifierProvider(create: (_) => FcmMessagesProvider()),
      ChangeNotifierProvider(create: (_) => HelpSidebarContentsProvider()),
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
      ChangeNotifierProvider(create: (_) => ErrorLogsProvider()),
      ChangeNotifierProvider(create: (_) => InboxProvider()),
      // ~cb-add-notifier~
    ];
  }
}
