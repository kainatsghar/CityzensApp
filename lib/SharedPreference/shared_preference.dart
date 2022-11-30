import 'package:shared_preferences/shared_preferences.dart';

class AppLocalData {
  static Future<void> setStringPrefValue({String key, String value}) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static Future<void> setBoolPrefValue({String key, bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<String> getStringPrefValue({String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> getBoolPrefValue({String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<dynamic> removeKeyData({String key}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
