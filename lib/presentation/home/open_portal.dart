import 'package:flutter/material.dart';
import 'package:mychat/presentation/screens/profile_screen.dart';
import 'package:mychat/presentation/home/home.dart';
import 'package:mychat/presentation/screens/status_page.dart';

class OpenPortal extends StatefulWidget {
  const OpenPortal({super.key});
  static final List<Widget> _screen = [
    Home(),
    StatusPage(),
    ProfileScreen()
  ];

  @override
  State<OpenPortal> createState() => _OpenPortalState();
}

class _OpenPortalState extends State<OpenPortal> {
  int _currentIndex = 0;
  void onTap(int i) {
    _currentIndex = i;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OpenPortal._screen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Status',
            icon: Icon(Icons.cameraswitch_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
    );
  }
}
