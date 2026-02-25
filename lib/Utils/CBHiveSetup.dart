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
