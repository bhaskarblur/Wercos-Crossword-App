import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getPrefs(String data) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(data);
  }

  static clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static setPrefs(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
  }

  static setBool(String key, bool data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, data);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static getDeviceToken() async {
    final fcmtoken = await FirebaseMessaging.instance.getToken();
    return fcmtoken!;
  }

  static deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
