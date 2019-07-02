import 'package:flutter/material.dart';
import 'package:legi/src/dashboard.dart';
import 'package:legi/src/history.dart';
// // import 'package:legi/src/account.dart';
// import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:legi/src/profile_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;

  final List<Widget> screens = [Dashboard(), History(), ProfilePage()];
  Widget currentScreen = Dashboard();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(child: currentScreen, bucket: bucket),
      bottomNavigationBar: FancyBottomNavigation(
        onTabChangedListener: (i) {
        setState(() {
        currentTab = i;
        currentScreen = screens[i];
        });
    },
        tabs: [
          TabData(iconData: Icons.home, title: "Dashboard"),
        TabData(iconData: Icons.history, title: "History"),
        TabData(iconData: Icons.person, title: "Account")
        ],
      ),
    );
  }
}
