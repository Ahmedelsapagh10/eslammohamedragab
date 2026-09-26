import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/login/data/model/login_model.dart';
import '../utils/app_strings.dart';

late SharedPreferences prefs;
late FlutterSecureStorage secureStorage;

class Preferences {
  static final Preferences instance = Preferences._internal();

  Preferences._internal();

  factory Preferences() => instance;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// Save user securely
  Future<void> setUser(LoginModel loginModel) async {
    String userJson = jsonEncode(LoginModel.fromJson(loginModel.toJson()));
    await secureStorage.write(key: 'user', value: userJson);
  }

  /// Retrieve user securely
  Future<LoginModel> getUserModel() async {
    String? jsonData = await secureStorage.read(key: 'user');
    if (jsonData != null) {
      return LoginModel.fromJson(jsonDecode(jsonData));
    } else {
      return LoginModel();
    }
  }

  Future<bool> clearUser() async {
    await secureStorage.delete(key: 'user');
    return true;
  }

  /// Save app language using SharedPreferences
  Future<void> savedLang(String local) async {
    await prefs.setString(AppStrings.locale, local);
  }

  /// Get app language using SharedPreferences
  Future<String> getSavedLang() async {
    return prefs.getString(AppStrings.locale) ?? 'ar'; // Default to 'ar'
  }

  /// Save app language using SharedPreferences

  /// Clear all data from secure storage and shared preferences
  Future<void> clearAll() async {
    await secureStorage.deleteAll(); // Clear secure storage
    await prefs.clear(); // Clear shared preferences
  }

  Future<void> setDeviceToken(String token) async {
    debugPrint('=====>> $token');
    await prefs.setString('device_token', token);
  }

  /// Get app language using SharedPreferences
  Future<String> getDeviceToken() async {
    return prefs.getString('device_token') ?? 'device_token';
  }
}
