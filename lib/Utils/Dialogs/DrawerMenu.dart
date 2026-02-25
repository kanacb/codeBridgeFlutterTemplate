import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// CodeBridge Standard Widgets Imports
import '../Methods.dart';
import '../Services/SharedPreferences.dart';
import '../../App/Dash/DashMain.dart';
import '../../CBWidgets/Profiles/ProfilesProvider.dart';
import '../../CBWidgets/Profiles/Profile.dart';
import '../../CBWidgets/Users/UsersMain.dart';
import '../../CBWidgets/Companies/CompaniesMain.dart';
import '../../CBWidgets/Branches/BranchesMain.dart';
import '../../CBWidgets/Departments/DepartmentsMain.dart';
import '../../CBWidgets/Sections/SectionsMain.dart';
import '../../CBWidgets/Roles/RolesMain.dart';
import '../../CBWidgets/Positions/PositionsMain.dart';
import '../../CBWidgets/Profiles/ProfilesMain.dart';
import '../../CBWidgets/Templates/TemplatesMain.dart';
import '../../CBWidgets/UserAddresses/UserAddressesMain.dart';
import '../../CBWidgets/CompanyAddresses/CompanyAddressesMain.dart';
import '../../CBWidgets/CompanyPhones/CompanyPhonesMain.dart';
import '../../CBWidgets/UserPhones/UserPhonesMain.dart';
import '../../CBWidgets/Staffinfo/StaffinfoMain.dart';
import '../../CBWidgets/Employees/EmployeesMain.dart';
import '../../CBWidgets/Superiors/SuperiorsMain.dart';
import '../../CBWidgets/DepartmentAdmin/DepartmentAdminMain.dart';
import '../../CBWidgets/DepartmentHOD/DepartmentHODMain.dart';
import '../../CBWidgets/DepartmentHOS/DepartmentHOSMain.dart';
import '../../CBWidgets/UserGuideSteps/UserGuideStepsMain.dart';
import '../../CBWidgets/UserGuide/UserGuideMain.dart';
import '../../CBWidgets/Audits/AuditsMain.dart';
import '../../CBWidgets/ChataiEnabler/ChataiEnablerMain.dart';
import '../../CBWidgets/ChataiConfig/ChataiConfigMain.dart';
import '../../CBWidgets/ChataiPrompts/ChataiPromptsMain.dart';
import '../../CBWidgets/DocumentStorages/DocumentStoragesMain.dart';
import '../../CBWidgets/Fcms/FcmsMain.dart';
import '../../CBWidgets/FcmQues/FcmQuesMain.dart';
import '../../CBWidgets/FcmMessages/FcmMessagesMain.dart';
import '../../CBWidgets/HelpSidebarContents/HelpSidebarContentsMain.dart';
import '../../CBWidgets/LoginHistories/LoginHistoriesMain.dart';
import '../../CBWidgets/MailQues/MailQuesMain.dart';
import '../../CBWidgets/ProfileMenu/ProfileMenuMain.dart';
import '../../CBWidgets/MenuItems/MenuItemsMain.dart';
import '../../CBWidgets/Uploader/UploaderMain.dart';
import '../../CBWidgets/UserChangePassword/UserChangePasswordMain.dart';
import '../../CBWidgets/UserInvites/UserInvitesMain.dart';
import '../../CBWidgets/UserTrackerId/UserTrackerIdMain.dart';
import '../../CBWidgets/PermissionServices/PermissionServicesMain.dart';
import '../../CBWidgets/PermissionFields/PermissionFieldsMain.dart';
import '../../CBWidgets/ErrorLogs/ErrorLogsMain.dart';
import '../../CBWidgets/Inbox/InboxMain.dart';
// CodeBridge Standard Widgets Ends here

// Custom imports for the drawer menu and permissions.
import '../../Widgets/Products/ProductsMain.dart';
import '../../Widgets/Orders/OrdersMain.dart';
import '../../Widgets/Customers/CustomersMain.dart';
import '../../Widgets/Items/ItemsMain.dart';
// ~cb-service-widget~

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  Profile? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _loadSelectedProfile();
  }

  void _loadSelectedProfile() async {
    var storedProfile = await getPref("selectedProfile");
    if (storedProfile != null) {
      try {
        final profiles = ProfilesProvider().data;
        Profile profile = profiles.firstWhere((p) => p.id == storedProfile);
        // Print the profile JSON so you can see what was loaded.
        setState(() {
          _selectedProfile = profile;
        });
      } catch (e) {
        savePref(
          "selectedProfile",
          ProfilesProvider().data.first.id.toString(),
        );
        setState(() {
          _selectedProfile = ProfilesProvider().data.first;
        });
        print("DEBUG: Error parsing stored profile: $e");
      }
    } else {
      savePref("selectedProfile", ProfilesProvider().data.first.id.toString());
      setState(() {
        _selectedProfile = ProfilesProvider().data.first;
      });
    }
  }

  // Function to check if the current profile can access a feature.
  bool hasAccess(String role, String feature, {String? companyType}) {
    // Updated permission strings according to requirements.

    Map<String, List<String>> rolePermissions = {
      "Super": [
        // Super admin same as Admin.
        "Dashboard",
        "Users",
        "Companies",
        "Branches",
        "Departments",
        "Sections",
        "Roles",
        "Positions",
        "Profiles",
        "Templates",
        "User Addresses",
        "Company Addresses",
        "Company Phones",
        "User Phones",
        "Staffinfo",
        "Employees",
        "Superiors",
        "Department Admin",
        "Department HOD",
        "Department HOS",
        "User Guide Steps",
        "User Guide",
        "Audits",
        "Chatai Enabler",
        "Chatai Config",
        "Chatai Prompts",
        "Document Storages",
        "Fcms",
        "Fcm Ques",
        "Fcm Messages",
        "Help Sidebar Contents",
        "Login Histories",
        "Mail Ques",
        "Profile Menu",
        "Menu Items",
        "Uploader",
        "User Change Password",
        "User Invites",
        "User Tracker Id",
        "Permission Services",
        "Permission Fields",
        "Error Logs",
        "Inbox",
      ],
    };
    // if (kDebugMode) {
    //   print(rolePermissions[role]);
    // }
    Map<String, List<String>> companyRestriction = {};

    // admin super bypass companyType
    if (role == 'Admin' || role == 'Super') {
      return rolePermissions[role]?.contains(feature) ?? false;
    }

    //check feature restriction
    if (companyType != null) {
      if (rolePermissions[role]?.contains(feature) ?? false) {
        return companyRestriction[companyType]?.contains(feature) ?? false;
      }
    }

    // check normal role permission
    return rolePermissions[role]?.contains(feature) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // print("DEBUG: In build, _selectedProfile: ${_selectedProfile?.toJson()}");
    String role = _selectedProfile?.position?.name ?? "";
    String companyType = _selectedProfile != null
        ? Methods.getCompanyFromProfile(_selectedProfile!)?.companyNo ?? ""
        : "";
    print("DEBUG: Role being used: '$role'");

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer header.
          SizedBox(
            height: 100.0,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logos/codebridge-logo.png",
                    height: 35,
                    alignment: Alignment.topCenter,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "App",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dashboard Section.
          if (hasAccess(role, "Dashboard"))
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Dashboard(i: 1)),
                );
              },
            ),
        ],
      ),
    );
  }
}
