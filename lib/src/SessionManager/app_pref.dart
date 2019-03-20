import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class SessionManager {
  static final _isLogin = 'isLogin';

  static Future<bool> getIsLogin() async{
    final SharedPreferences prefs =await SharedPreferences.getInstance();
    return prefs.getBool(_isLogin) ?? false;

  }

 

  static Future<bool> setIsLogin(bool value) async{
    final SharedPreferences prefs =await SharedPreferences.getInstance();
    return prefs.setBool(_isLogin, value);
  }

  static Future<bool> logout() async{
    final SharedPreferences prefs =await SharedPreferences.getInstance();
    return prefs.setBool(_isLogin, false);
    
  }
  
 
  
}