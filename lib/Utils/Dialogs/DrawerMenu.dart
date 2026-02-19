import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Methods.dart';
import '../Services/SharedPreferences.dart';
import '../../App/Dash/DashMain.dart';
import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../App/MenuBottomBar/Profile/ProfileProvider.dart';
import '../../Widgets/Users/UserPage.dart';

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
        final profiles = ProfileProvider().profiles;
        Profile profile = profiles.firstWhere((p) => p.id == storedProfile);
        // Print the profile JSON so you can see what was loaded.
        setState(() {
          _selectedProfile = profile;
        });
      } catch (e) {
        savePref("selectedProfile", ProfileProvider().profiles.first.id);
        setState(() {
          _selectedProfile = ProfileProvider().profiles.first;
        });
        print("DEBUG: Error parsing stored profile: $e");
      }
    } else {
      savePref("selectedProfile", ProfileProvider().profiles.first.id);
      setState(() {
        _selectedProfile = ProfileProvider().profiles.first;
      });
    }
  }

  // Function to check if the current profile can access a feature.
  bool hasAccess(String role, String feature, {String? companyType}) {
    // Updated permission strings according to requirements.

    Map<String, List<String>> rolePermissions = {
      "Vending Controller": [
        "Dashboard",
        "Raise Atlas Ticket",
        "Atlas Tickets",
      ],
      "Salesman": ["Dashboard", "Raise MEM Ticket", "MEM Tickets"],
      "External": ["Dashboard", "Raise External Ticket", "External Tickets"],
      "Incomingmachinechecker": [
        "Dashboard",
        "Raise Incoming Ticket",
        "Incoming Machines",
      ],
      "Technician": [
        // Technician sees only Atlas Tickets, External Tickets and Job Stations.
        "Dashboard",
        "Atlas Tickets",
        "External Tickets",
        "Job Stations",
        "MEM Tickets",
      ],
      "Supervisor": [
        // Supervisor sees only Atlas Tickets, External Tickets and Incoming Machines.
        "Dashboard",
        "Raise Atlas Ticket",
        "Raise MEM Ticket",
        "Atlas Tickets",
        "External Tickets",
        "Incoming Machines",
        "MEM Tickets",
      ],
      "Incoming Machine Checker": ["Dashboard", "Incoming Machines"],
      "Storekeeper": [
        // Storekeeper only sees stocks and sales orders.
        "Dashboard",
        "Stock-In",
        "Stock-Out",
        "Parts Requests",
        "Transfers",
        "Samples",
        "Disposals",
        "Sales - Sales Orders",
        "Sales - Quotations",
        "Sales - Purchase Orders",
        "Sales - Delivery Orders",
      ],
      "Admin": [
        // Admin sees most things.
        "Dashboard",
        "Atlas Tickets",
        "Atlas Checks",
        "Atlas Checklists",
        "Stock-In",
        "Stock-Out",
        "Parts Requests",
        "Transfers",
        "Samples",
        "Disposals",
        "Sales - Sales Orders",
        "Sales - Quotations",
        "Sales - Purchase Orders",
        "Sales - Delivery Orders",
        "Master - Machines",
        "Master - Parts",
        "Master - Job Stations",
        "Master - Vending Machines",
        "Master - Operation Centres",
        "Master - Warehouses",
        // Extra groups for Admin:
        "User Management",
        "External Tickets",
        "MEM Tickets",
        "Job Stations",
        "Incoming Machines",
        "Customer Orders",
        "IRMS Orders",
      ],
      "Super": [
        // Super admin same as Admin.
        "Dashboard",
        "Raise Atlas Ticket",
        "Atlas Ticket List",
        "Atlas Checks",
        "Atlas Checklists",
        "Stock-In",
        "Stock-Out",
        "Parts Requests",
        "Transfers",
        "Samples",
        "Disposals",
        "Sales - Sales Orders",
        "Sales - Quotations",
        "Sales - Purchase Orders",
        "Sales - Delivery Orders",
        "Master - Machines",
        "Master - Parts",
        "Master - Job Stations",
        "Master - Vending Machines",
        "Master - Operation Centres",
        "Master - Warehouses",
        "User Management",
        "External Tickets",
        "MEM Tickets",
        "Job Stations",
        "Incoming Machines",
        "Customer Orders",
        "IRMS Orders",
      ],
    };
    // if (kDebugMode) {
    //   print(rolePermissions[role]);
    // }
    Map<String, List<String>> companyRestriction = {
      "atlas": ["Raise Atlas Ticket", "Atlas Tickets"],
      "irms": [
        "Raise External Ticket",
        "Raise Incoming Ticket",
        "External Tickets",
        "Job Stations",
        "Incoming Machines",
      ],
      "etika": ["Raise MEM Ticket", "MEM Tickets"],
      "external": ["Raise External Ticket", "External Tickets"],
      "External": ["Raise External Ticket", "External Tickets"],
    };

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
        ? Methods.getCompanyFromProfile(_selectedProfile!)?.companyType ?? ""
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
                    "assets/logos/atlas-logo.jpg",
                    height: 35,
                    alignment: Alignment.topCenter,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "AIMS",
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
