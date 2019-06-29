import 'dart:async';
import 'package:flutter/material.dart';
import 'package:legi/src/SessionManager/app_pref.dart';



class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreenState2 createState() => _SplashScreenState2();
}

class _SplashScreenState2 extends State<SplashScreen2> {
  startTime() async{
    var _duration =Duration(seconds: 2);
    bool _prefs =await SessionManager.getIsLogin();


    if (_prefs) {
      return Timer(_duration, () => Navigator.of(context).pushReplacementNamed('/home'));
    }else{
      return Timer(_duration, () => Navigator.of(context).pushReplacementNamed('/login_page'));

    }
  }
  
  @override
  void initState() {
    super.initState();
    startTime();
  }
    
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0091EA),  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/letgiving-square.png', scale: 3.0,),
            // Text('Lets Giving', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),)
          ],
        )
        
      ),
    );
  }
}
