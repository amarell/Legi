import 'package:flutter/material.dart';
import 'package:legi/src/dashboard.dart';
import 'package:legi/src/history.dart';
import 'package:legi/src/account.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currentTab = 0;

  final List<Widget> screens = [
    Dashboard(), History(), Account()
  ];
  Widget currentScreen = Dashboard();

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: PageStorage(child: currentScreen, bucket: bucket),
      bottomNavigationBar: bmnav.BottomNav(
        index: currentTab,
        onTap: (i){
          setState(() {
           currentTab=i;
           currentScreen = screens[i];

          });
        },
         items: [
          bmnav.BottomNavItem(Icons.home, label: 'Dashboard'),
          bmnav.BottomNavItem(Icons.fitness_center, label: 'History'),
          bmnav.BottomNavItem(Icons.person, label: 'Account'),
        ],
      ),
      
    );
  }
}