import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rename/platform_file_editors/abs_platform_file_editor.dart';

import 'DataFetchable.dart';
import '../../CBWidgets/Users/UsersProvider.dart';
import '../../CBWidgets/Companies/CompaniesProvider.dart';
import '../../CBWidgets/Branches/BranchesProvider.dart';
import '../../CBWidgets/Departments/DepartmentsProvider.dart';
import '../../CBWidgets/Sections/SectionsProvider.dart';
import '../../CBWidgets/Roles/RolesProvider.dart';
import '../../CBWidgets/Positions/PositionsProvider.dart';
import '../../CBWidgets/Profiles/ProfilesProvider.dart';
import '../../CBWidgets/Templates/TemplatesProvider.dart';
import '../../CBWidgets/UserAddresses/UserAddressesProvider.dart';
import '../../CBWidgets/CompanyAddresses/CompanyAddressesProvider.dart';
import '../../CBWidgets/CompanyPhones/CompanyPhonesProvider.dart';
import '../../CBWidgets/UserPhones/UserPhonesProvider.dart';
import '../../CBWidgets/Staffinfo/StaffinfoProvider.dart';
import '../../CBWidgets/Employees/EmployeesProvider.dart';
import '../../CBWidgets/Superiors/SuperiorsProvider.dart';
import '../../CBWidgets/DepartmentAdmin/DepartmentAdminProvider.dart';
import '../../CBWidgets/DepartmentHOD/DepartmentHODProvider.dart';
import '../../CBWidgets/DepartmentHOS/DepartmentHOSProvider.dart';
import '../../CBWidgets/UserGuideSteps/UserGuideStepsProvider.dart';
import '../../CBWidgets/UserGuide/UserGuideProvider.dart';
import '../../CBWidgets/Audits/AuditsProvider.dart';
import '../../CBWidgets/ChataiEnabler/ChataiEnablerProvider.dart';
import '../../CBWidgets/ChataiConfig/ChataiConfigProvider.dart';
import '../../CBWidgets/ChataiPrompts/ChataiPromptsProvider.dart';
import '../../CBWidgets/DocumentStorages/DocumentStoragesProvider.dart';
import '../../CBWidgets/Fcms/FcmsProvider.dart';
import '../../CBWidgets/FcmQues/FcmQuesProvider.dart';
import '../../CBWidgets/FcmMessages/FcmMessagesProvider.dart';
import '../../CBWidgets/HelpSidebarContents/HelpSidebarContentsProvider.dart';
import '../../CBWidgets/LoginHistories/LoginHistoriesProvider.dart';
import '../../CBWidgets/MailQues/MailQuesProvider.dart';
import '../../CBWidgets/ProfileMenu/ProfileMenuProvider.dart';
import '../../CBWidgets/MenuItems/MenuItemsProvider.dart';
import '../../CBWidgets/Uploader/UploaderProvider.dart';
import '../../CBWidgets/UserChangePassword/UserChangePasswordProvider.dart';
import '../../CBWidgets/UserInvites/UserInvitesProvider.dart';
import '../../CBWidgets/UserTrackerId/UserTrackerIdProvider.dart';
import '../../CBWidgets/PermissionServices/PermissionServicesProvider.dart';
import '../../CBWidgets/PermissionFields/PermissionFieldsProvider.dart';
import '../../CBWidgets/ErrorLogs/ErrorLogsProvider.dart';
import '../../CBWidgets/Inbox/InboxProvider.dart';
// ~cb-data-initializer-provider-import~

class DataInitializer {
  final BuildContext context;

  DataInitializer(this.context);

  // List of providers to initialize
  final Map<String, DataFetchable> Function(BuildContext) _providerMap =
      (ctx) => {
        //'companies': Provider.of<CompanyProvider>(ctx, listen: false),
        // ~cb-data-initializer-provider-map~
      };

  // Method to initialize all providers' fetchAllAndSave methods
  Future<void> initializeAll() async {
    final registry = _providerMap(context);

    await Future.wait(
      registry.values.map((provider) {
        return provider.fetchAllAndSave();
      }),
    );
  }

  Future<void> fetchByName(String providerName) async {
    final registry = _providerMap(context);
    final provider = registry[providerName];
    if (provider == null) {
      throw Exception("No provider found with name '$providerName'.");
    }
    await provider.fetchAllAndSave();
  }
}
