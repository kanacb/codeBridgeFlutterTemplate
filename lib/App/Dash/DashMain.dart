import 'dart:convert';

import '../../Utils/Services/Response.dart';
import '../../Widgets/DataInitializer/DataInitializer.dart';

import '../../Widgets/Users/User.dart';
import '/../../App/Dash/CardSelection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../Login/Services/authService.dart';
import '../../App/Dash/DashExistingUser.dart'; // Not used directly now
import '../../App/Dash/NewUserDash.dart';
import '../../App/Dash/Notifications/NotificationPage.dart';
import '../../App/Dash/Notifications/NotificationProvider.dart';
import '../../Utils/Dialogs/BuildSvgIcon.dart';
import '../../Utils/Dialogs/DrawerMenu.dart';
import '../../Utils/Globals.dart' as globals;
import '../../Utils/Services/SharedPreferences.dart';
import '../../Utils/PageUtils.dart';
import '../MenuBottomBar/Inbox/InboxPage.dart';
import '../MenuBottomBar/Profile/ProfilePopUp.dart';
import '../MenuBottomBar/Profile/ProfileProvider.dart';
import '../MenuBottomBar/Search/Search.dart';
import 'Notifications/CBNotification.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.i, this.index});
  final int i;
  final int? index;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  int _runonce = 0;
  bool _isLoggedIn = false;
  bool _isNewUser = true; // Default to new user (has not set up cards)
  Logger logger = globals.logger;
  Utils utils = Utils();
  AuthService auth = AuthService();
  User? _user;
  int _unreadCount = 0;
  bool _isLoadingNotifications = true;

  // For new users: show NewUserDash (which includes an image and the "Guide Me" button)
  final List<Widget> _newBodies = [
    NewUserDash(),
    const Search(),
    const InboxPage(),
  ];

  // For existing users: show ExistingUserDash (with a welcome message and cards)
  final List<Widget> _existingBodies = [
    const ExistingUserDash(),
    const Search(),
    const InboxPage(),
  ];

  @override
  void initState() {
    super.initState();
    _isLoggedInCheck();
    _init();
  }

  Future<void> _init() async {
    setState(() => _isLoadingNotifications = true);

    _user = User.fromJson(jsonDecode(await getPref("user") ?? ""));

    // save into the provider so can be access in NotificationPage
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    Response response = await notificationProvider.fetchByToUserAndSave(_user?.id ?? "");
    List<CBNotification> result = response.data;

    _unreadCount = result.where((notification) => notification.read == false).toList().length;

    setState(() {
      _isLoadingNotifications = false;
      print("unreadCount: $_unreadCount");
    });
  }

  // Bottom navigation on tap – if index 3 (Profile), show a bottom sheet.
  void _onTabTapped(int index) {
    if (index == 1) { //todo check this back to 3, since i've commented out search and inbox
      _showBottomSheet();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // Check login status and whether the user has completed their card setup.
  void _isLoggedInCheck() async {
    final remember = await getPref("remember");
    final userSetup = await getPref(
      "user_setup",
    ); // This flag tells if setup is complete
    if (kDebugMode) {
      print("userSetup $userSetup");
    }

    if (remember == 'true') {
      await auth.trySilentLogin();
    }
    bool result = await auth.reauthenticate();
    logger.i(
      "status $_isLoggedIn, remember $remember, result ${result.toString()}",
    );

    setState(() {
      _isLoggedIn = result;
      _isNewUser = userSetup != "done"; // If not "done", the user is new
    });

    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).fetchAllAndSave();
    } else {
      await savePref("login", "no");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index != null && widget.index! > 0 && _runonce == 0) {
      setState(() {
        _currentIndex = widget.index!;
        _runonce = 1;
      });
    }

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerMenu(),
      // Show NewUserDash or ExistingUserDash based on the _isNewUser flag.
      body:
          _isNewUser
              ? _newBodies[_currentIndex]
              : _existingBodies[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        useLegacyColorScheme: true,
        items: [
          BottomNavigationBarItem(
            // Loads an icon image via BuildSvgIcon from assets/svg/home.svg
            icon: BuildSvgIcon(
              assetName: 'assets/svg/home.svg',
              index: 0,
              currentIndex: _currentIndex,
            ),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: BuildSvgIcon(
          //     assetName: 'assets/svg/search.svg',
          //     index: 1,
          //     currentIndex: _currentIndex,
          //   ),
          //   label: 'Search',
          // ),
          // BottomNavigationBarItem(
          //   icon: BuildSvgIcon(
          //     assetName: 'assets/svg/inbox.svg',
          //     index: 2,
          //     currentIndex: _currentIndex,
          //   ),
          //   label: 'Inbox',
          // ),
          BottomNavigationBarItem(
            icon: BuildSvgIcon(
              assetName: 'assets/svg/emptyProfile.svg',
              index: 3,
              currentIndex: _currentIndex,
            ),
            label: 'Profile',
          ),
        ],
      ),
      // "Manage Cards" button appears only for existing users.
      floatingActionButton:
          !_isNewUser
              ? FloatingActionButton(
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CardSelectionPage(),
                      ),
                    ),
                child: const Icon(Icons.credit_card),
              )
              : null,
    );
  }

  // AppBar with a menu, logo (via BuildSvgIcon) and notifications button.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logos/atlas-logo.jpg",
            height: 35,
            alignment: Alignment.topCenter,
          ),
          SizedBox(width: 10),
          Text("AIMS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        ],
      ),
      // actions: [
      //   _buildNotificationIcon(),
      // ],
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.red,
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: _isLoadingNotifications
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Icon(Icons.notifications),
          onPressed: _isLoadingNotifications ? null : _showNotificationSheet,
        ),
        // unread notification badge overlay
        if (!_isLoadingNotifications && _unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  _unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Shows a bottom sheet for the Profile.
  void _showBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext _) {
        return ProfilePopUp(parentContext: context,);
      },
    );
  }

  void _showNotificationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      builder: (BuildContext _) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: NotificationPage(),
        );
      },
    );
  }
}
