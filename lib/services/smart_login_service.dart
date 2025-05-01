import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/smart_login_response.dart';

class SmartLoginService {
  static const String _storageKey = 'smart_login_data';

  static Future<void> saveLoginData(SmartLoginResponse loginData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(loginData.toJson()));
  }

  static Future<SmartLoginResponse?> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      return SmartLoginResponse.fromJson(jsonDecode(data));
    }
    return null;
  }

  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}