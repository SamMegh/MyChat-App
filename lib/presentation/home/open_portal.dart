import 'package:flutter/material.dart';
import 'package:mychat/presentation/chat/profile_screen.dart';
import 'package:mychat/presentation/home/home.dart';

class OpenPortal extends StatefulWidget {
  const OpenPortal({super.key});
  static final List<Widget> _screen = [
    Home(),
    ProfileScreen()
  ];

  @override
  State<OpenPortal> createState() => _OpenPortalState();
}

class _OpenPortalState extends State<OpenPortal> {
  int _currentIndex = 1;
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
            label: 'Profile',
            icon: Icon(Icons.manage_accounts_outlined),
          ),
        ],
      ),
    );
  }
}
