import 'package:flutter/material.dart';
import 'package:legi/splashscreen.dart';
import 'package:legi/src/login.dart';
import 'package:legi/src/login_page.dart';
import 'package:legi/src/home.dart';
class App extends StatelessWidget {

  final Map<String, WidgetBuilder> routes= {
    '/login': (context) => Login(),
    '/login_page': (context) => LoginPage(),
    '/home' : (context) => Home(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Legi',
      debugShowCheckedModeBanner: false,
      home: SplashScreen2(),
      routes: routes,
      theme: ThemeData(
        primaryColor: Colors.green[600],
        accentColor: Colors.red,
      ),
      
    );
  }
}