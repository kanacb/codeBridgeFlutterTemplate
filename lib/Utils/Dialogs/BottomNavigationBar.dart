import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../App/Dash/DashMain.dart';
import '../../App/MenuBottomBar/Profile/ProfilePopUp.dart';
import 'BuildSvgIcon.dart';

class CBBottomNavigationBar extends StatefulWidget {
  const CBBottomNavigationBar({super.key,});

  @override
  State<CBBottomNavigationBar> createState() => _CBBottomNavigationBarState();
}

class _CBBottomNavigationBarState extends State<CBBottomNavigationBar> {
  final int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 1) { //todo check this back to 3, since i've commented out search and inbox
      _showBottomSheet();
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => Dashboard(i:1, index: index,)));
    }
  }

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

  @override
  Widget build(BuildContext context) {
    BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      unselectedLabelStyle: TextStyle(color: Colors.grey, fontSize: 12),
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      backgroundColor: Colors.white,
      fixedColor: Colors.black87,
      unselectedItemColor: Colors.grey,
      useLegacyColorScheme: true,
      items: [
        BottomNavigationBarItem(
          icon: BuildSvgIcon(
              assetName: 'assets/svg/home.svg',
              index: 0,
              currentIndex: _currentIndex),
          label: 'Home',
        ),
        // BottomNavigationBarItem(
        //   icon: BuildSvgIcon(
        //       assetName: 'assets/svg/search.svg',
        //       index: 1,
        //       currentIndex: _currentIndex),
        //   label: 'Search',
        // ),
        // BottomNavigationBarItem(
        //   icon: BuildSvgIcon(
        //       assetName: 'assets/svg/inbox.svg',
        //       index: 2,
        //       currentIndex: _currentIndex),
        //   label: 'Inbox',
        // ),
        BottomNavigationBarItem(
          icon: BuildSvgIcon(
              assetName: 'assets/svg/emptyProfile.svg',
              index: 3,
              currentIndex: _currentIndex),
          label: 'Profile',
        ),
      ],
    );

    return bottomNavigationBar;
  }
}
