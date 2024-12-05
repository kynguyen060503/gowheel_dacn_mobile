import 'package:flutter/material.dart';
import 'package:gowheel_flutterflow_ui/pages/home_user.dart';
import 'package:gowheel_flutterflow_ui/pages/list_favorite.dart';
import 'package:gowheel_flutterflow_ui/pages/main_profile.dart';
import 'package:gowheel_flutterflow_ui/pages/notification.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  List<Widget> _widgetOptions() {
    return [
      const HomePage(),
      FavoritePage(),
      NotificationPage(),
      const MainProfileWidget()
    ];
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _widgetOptions(),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite),
              title: const Text("Likes"),
              selectedColor: Colors.pink,
            ),

            /// NOtification
            SalomonBottomBarItem(
              icon: const Icon(Icons.notifications),
              title: const Text("Notification"),
              selectedColor: Colors.orange,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.teal,
            ),
          ],
        ),

          
        ),
      );
  }
}

