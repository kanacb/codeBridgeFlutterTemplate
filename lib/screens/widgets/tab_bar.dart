import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vx_index/global.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({super.key, required this.onItemTapped});
  final onItemTapped;

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return admin(context);
  }

  Widget admin(context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: colorPrimary),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Admin',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Trends',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  Widget buyer(context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: colorPrimary),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Buyer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Trends',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: widget.onItemTapped(_selectedIndex),
    );
  }

  Widget seller(context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: colorPrimary),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Seller',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Trends',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: widget.onItemTapped(_selectedIndex),
    );
  }
}
