import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<void> saveUserCredentials({
    required String email,
    required String password,
    required bool keepLoggedIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (keepLoggedIn) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('keepLoggedIn', true);
    } else {
      await clearUserCredentials();
    }
  }

  Future<Map<String, dynamic>> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email') ?? '',
      'password': prefs.getString('password') ?? '',
      'keepLoggedIn': prefs.getBool('keepLoggedIn') ?? false,
    };
  }

  Future<void> clearUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('keepLoggedIn', false);
  }
}