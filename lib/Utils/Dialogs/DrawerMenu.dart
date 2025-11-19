import 'dart:convert';
import 'package:aims/Widgets/MemTickets/MemTicketPage.dart';
import 'package:aims/Widgets/RaiseTicket/QrCodeScanner.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Widgets/DeliveryOrderItems/DeliveryOrderItemsPage.dart';
import '../../Widgets/DisposalDetails/DisposalDetailsPage.dart';
import '../../Widgets/MachineMaster/MachineMasterPage.dart';
import '../../Widgets/PartsMaster/PartsMasterPage.dart';
import '../../Widgets/PurchaseOrderItems/PurchaseOrderItemsPage.dart';
import '../../Widgets/QuotationItems/QuotationItemsPage.dart';
import '../../Widgets/WarehouseMaster/WarehouseMasterPage.dart';
import '../../Widgets/AtlasChecklists/AtlasChecklistsPage.dart';
import '../../Widgets/AtlasChecks/AtlasChecksPage.dart';
import '../../Widgets/AtlasTickets/AtlasTicketPage.dart';
import '../../Widgets/JobStations/JobStationsPage.dart';
import '../../Widgets/PartRequestDetails/PartRequestDetailsPage.dart';
import '../../Widgets/SalesOrderItems/SalesOrderItemsPage.dart';
import '../../Widgets/SampleDetails/SampleDetailsPage.dart';
import '../../Widgets/StockInDetails/StockInDetailsPage.dart';
import '../../Widgets/StockOutDetails/StockOutDetailsPage.dart';
import '../../Widgets/TransferDetails/TransferDetailsPage.dart';

import '../../Widgets/ExternalTickets/ExternalTicketsPage.dart';
import '../../Widgets/ExternalChecks/ExternalChecksPage.dart';
import '../../Widgets/ExternalChecklists/ExternalChecklistsPage.dart';
import '../../Widgets/IncomingMachineChecks/IncomingMachineChecksPage.dart';
import '../../Widgets/IncomingMachineChecklists/IncomingMachineChecklistsPage.dart';
import '../../Widgets/CustomerPurchaseOrders/CustomerPurchaseOrdersPage.dart';
import '../../Widgets/CustomerSalesOrders/CustomerSalesOrdersPage.dart';
import '../../Widgets/irmsQuotations/irmsQuotationsPage.dart';

import '../../App/Dash/DashMain.dart';
import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../App/MenuBottomBar/Profile/ProfileProvider.dart';
import '../../Widgets/IncomingMachineTickets/IncomingMachineTicketPage.dart';
import '../../Widgets/JobStationTickets/JobStationTicketPage.dart';
import '../../Widgets/Users/UserPage.dart';
import '../../Widgets/irmsDeliveryOrder/irmsDeliveryOrdersPage.dart';
import '../Methods.dart';
import '../Services/SharedPreferences.dart';

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
      "Vending Controller": ["Dashboard", "Raise Atlas Ticket", "Atlas Tickets"],
      "Salesman": ["Dashboard", "Raise MEM Ticket", "MEM Tickets"],
      "External": ["Dashboard", "Raise External Ticket", "External Tickets"],
      "Incomingmachinechecker": ["Dashboard", "Raise Incoming Ticket", "Incoming Machines"],
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
      "atlas": [
        "Raise Atlas Ticket",
        "Atlas Tickets",
      ],
      "irms": [
        "Raise External Ticket",
        "Raise Incoming Ticket",
        "External Tickets",
        "Job Stations",
        "Incoming Machines"
      ],
      "etika": [
        "Raise MEM Ticket",
        "MEM Tickets",
      ],
      "external": [
        "Raise External Ticket",
        "External Tickets",
      ],
      "External": [
        "Raise External Ticket",
        "External Tickets",
      ],
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

          // Atlas Tickets Section.
          if (hasAccess(role, "Raise Atlas Ticket", companyType: companyType) ||
              hasAccess(role, "Raise MEM Ticket", companyType: companyType) ||
              hasAccess(role, "Raise External Ticket", companyType: companyType) ||
              hasAccess(role, "Raise Incoming Ticket", companyType: companyType))
            ListTile(
              leading: const Icon(Icons.support_outlined),
              title: const Text('Raise a Ticket'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QrCodeScanner(companyType: companyType,),
                  ),
                );
              },
            ),

          if (hasAccess(role, "Atlas Tickets", companyType: companyType))
            ListTile(
              leading: const Icon(Icons.support_outlined),
              title: const Text('Atlas Tickets'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AtlasTicketPage(),
                  ),
                );
              },
            ),

          if (hasAccess(role, "External Tickets", companyType: companyType))
            ListTile(
              leading: const Icon(Icons.support_outlined),
              title: const Text('External Tickets'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ExternalTicketsPage(),
                  ),
                );
              },
            ),

          if (hasAccess(role, "Job Stations", companyType: companyType) ||
              hasAccess(role, "Incoming Machines", companyType: companyType))
            ExpansionTile(
              leading: const Icon(Icons.my_library_add_outlined),
              title: const Text('Incoming Machines'),
              initiallyExpanded: false,
              children: [

                if (hasAccess(role, "Incoming Machines", companyType: companyType))
                  ListTile(
                    leading: Icon(Icons.ad_units_outlined),
                    title: const Text('Tickets'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => IncomingMachineTicketPage(),
                        ),
                      );
                    },
                  ),
                if (hasAccess(role, "Job Stations", companyType: companyType))
                  ListTile(
                    leading: Icon(Icons.wallet_giftcard_sharp),
                    title: const Text('Job Stations'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => JobStationTicketPage(),
                        ),
                      );
                    },
                  ),
              ],
            ),

          if (hasAccess(role, "MEM Tickets", companyType: companyType))
            ListTile(
              leading: const Icon(Icons.support_outlined),
              title: const Text('MEM Tickets'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MemTicketPage(),
                  ),
                );
              },
            ),

          // Stocks Section.
          // if (hasAccess(role, "Stock-In") ||
          //     hasAccess(role, "Stock-Out") ||
          //     hasAccess(role, "Parts Requests") ||
          //     hasAccess(role, "Transfers") ||
          //     hasAccess(role, "Samples") ||
          //     hasAccess(role, "Disposals"))
          //   ExpansionTile(
          //     leading: const Icon(Icons.storage),
          //     title: const Text('Stocks'),
          //     initiallyExpanded: false,
          //     children: [
          //       if (hasAccess(role, "Stock-In"))
          //         ListTile(
          //           title: const Text('Stock-In'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => StockInDetailsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Stock-Out"))
          //         ListTile(
          //           title: const Text('Stock-Out'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => StockOutDetailsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Parts Requests"))
          //         ListTile(
          //           title: const Text('Parts Requests'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => PartRequestDetailsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Transfers"))
          //         ListTile(
          //           title: const Text('Transfers'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => TransferDetailsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Samples"))
          //         ListTile(
          //           title: const Text('Samples'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => SampleDetailsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Disposals"))
          //         ListTile(
          //           title: const Text('Disposals'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => DisposalDetailsPage()),
          //             );
          //           },
          //         ),
          //     ],
          //   ),
          // Sales Orders Section.
          // if (hasAccess(role, "Sales - Sales Orders") ||
          //     hasAccess(role, "Sales - Quotations") ||
          //     hasAccess(role, "Sales - Purchase Orders") ||
          //     hasAccess(role, "Sales - Delivery Orders"))
          //   ExpansionTile(
          //     leading: const Icon(Icons.shopping_cart),
          //     title: const Text('Sales Orders'),
          //     initiallyExpanded: false,
          //     children: [
          //       if (hasAccess(role, "Sales - Sales Orders"))
          //         ListTile(
          //           title: const Text('Sales Order Items'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => SalesOrderItemsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Sales - Quotations"))
          //         ListTile(
          //           title: const Text('Quotation Items'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => QuotationItemsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Sales - Purchase Orders"))
          //         ListTile(
          //           title: const Text('Purchase Order Items'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => PurchaseOrderItemsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Sales - Delivery Orders"))
          //         ListTile(
          //           title: const Text('Delivery Order Items'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => DeliveryOrderItemsPage()),
          //             );
          //           },
          //         ),
          //     ],
          //   ),
          // Master Section.
          // if (hasAccess(role, "Master - Machines") ||
          //     hasAccess(role, "Master - Parts") ||
          //     hasAccess(role, "Master - Job Stations") ||
          //     hasAccess(role, "Master - Vending Machines") ||
          //     hasAccess(role, "Master - Operation Centres") ||
          //     hasAccess(role, "Master - Warehouses"))
          //   ExpansionTile(
          //     leading: const Icon(Icons.book),
          //     title: const Text('Master'),
          //     initiallyExpanded: false,
          //     children: [
          //       if (hasAccess(role, "Master - Machines"))
          //         ListTile(
          //           title: const Text('Machines'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => MachineMasterPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Master - Parts"))
          //         ListTile(
          //           title: const Text('Parts'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => PartsMasterPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Master - Job Stations"))
          //         ListTile(
          //           title: const Text('Job Stations'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => JobStationsPage()),
          //             );
          //           },
          //         ),
          //       if (hasAccess(role, "Master - Warehouses"))
          //         ListTile(
          //           title: const Text('Warehouses'),
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                   builder: (context) => WarehouseMasterPage()),
          //             );
          //           },
          //         ),
          //     ],
          //   ),
          // --- New Groups ---
          // User Management Group (only Admin/Super have "User Management" permission)
          // if (hasAccess(role, "User Management"))
          //   ExpansionTile(
          //     leading: const Icon(Icons.person),
          //     title: const Text('User Management'),
          //     initiallyExpanded: false,
          //     children: [
          //       ListTile(
          //         title: const Text('Users'),
          //         onTap: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(builder: (context) => UserPage()),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // External Tickets & Checks Group (visible if any of these permissions exist)

          // Customer Orders Group (only visible for Admin/Super)
          // if (hasAccess(role, "Customer Orders"))
          //   ExpansionTile(
          //     leading: const Icon(Icons.shopping_bag),
          //     title: const Text('Customer Orders'),
          //     initiallyExpanded: false,
          //     children: [
          //       ListTile(
          //         title: const Text('Customer Purchase Orders'),
          //         onTap: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //                 builder: (context) => CustomerPurchaseOrdersPage()),
          //           );
          //         },
          //       ),
          //       ListTile(
          //         title: const Text('Customer Sales Orders'),
          //         onTap: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //                 builder: (context) => CustomerSalesOrdersPage()),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // // IRMS Orders Group (only visible for Admin/Super)
          // if (hasAccess(role, "IRMS Orders"))
          //   ExpansionTile(
          //     leading: const Icon(Icons.local_shipping),
          //     title: const Text('IRMS Orders'),
          //     initiallyExpanded: false,
          //     children: [
          //       ListTile(
          //         title: const Text('IRMS Delivery Orders'),
          //         onTap: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //                 builder: (context) => irmsDeliveryOrdersPage()),
          //           );
          //         },
          //       ),
          //       ListTile(
          //         title: const Text('IRMS Quotations'),
          //         onTap: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //                 builder: (context) => irmsQuotationsPage()),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }
}
