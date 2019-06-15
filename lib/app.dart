import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legi/splashscreen.dart';
import 'package:legi/src/history.dart';
import 'package:legi/src/login.dart';
import 'package:legi/src/login_page.dart';
import 'package:legi/src/home.dart';
import 'package:legi/src/pages/dompet.dart';
class App extends StatelessWidget {

  final Map<String, WidgetBuilder> routes= {
    '/login': (context) => Login(),
    '/login_page': (context) => LoginPage(),
    '/home' : (context) => Home(),
    '/dompet' : (context) => Dompet(),
    '/history' : (context) => History(),
  };

  @override
  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      title: 'Legi',
      debugShowCheckedModeBanner: false,
      home: SplashScreen2(),
      routes: routes,
      theme: ThemeData(
        primaryColor: const Color(0xFF01579B),
        accentColor: Colors.red,
      ),
      
    );
  }
}