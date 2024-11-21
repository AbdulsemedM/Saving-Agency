// import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimplePreferences {
  static late SharedPreferences _preferences;
  static late String _keyLanguage;
  static late String _keyUser;
  static late String _keyIsOn;
  static late String _keyData;
  static late String _keyRefresh;

  static Future<SharedPreferences> init() async {
    _preferences = await SharedPreferences.getInstance();
    _keyLanguage = 'language';
    _keyUser = "user_key";
    _keyIsOn = "dark";
    _keyData = "data_key";
    _keyRefresh = "Refresh_key";
    return _preferences;
  }

  Future<void> setLanguage(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(_keyLanguage, language);
    if (kDebugMode) {
      print("setLang: $language");
    }
  }

  Future<void> setRefresh(String refresh) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(_keyRefresh, refresh);
    if (kDebugMode) {
      print("setRef: $refresh");
    }
  }

  Future<void> setUser(List<String> user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList(_keyUser, user); // Note: <String> is not needed here
    if (kDebugMode) {
      print("setUser: $user");
    }
  }

  Future<void> setData(List<String> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList(_keyData, data); // Note: <String> is not needed here
    if (kDebugMode) {
      print("setData: $data");
    }
  }

  Future<void> setIsOn(String isOn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyIsOn, isOn);

    print("setIsOn: $isOn");
  }

  Future<String?> getLanguage() async {
    final SharedPreferences prefs = _preferences;

    final language = prefs.getString('language');
    if (kDebugMode) {
      print("getLang: $language");
    }
    return language;
  }

  Future<String?> getRefresh() async {
    final SharedPreferences prefs = _preferences;

    final refresh = prefs.getString('Refresh_key');
    if (kDebugMode) {
      print("getRef: $refresh");
    }
    return refresh;
  }

  Future<List?> getUser() async {
    final SharedPreferences prefs = _preferences;

    final user = prefs.getStringList('user_key');
    if (kDebugMode) {
      print("getUser: $user");
    }
    return user;
  }

  Future<List?> getData() async {
    final SharedPreferences prefs = _preferences;

    final data = prefs.getStringList('data_key');
    if (kDebugMode) {
      print("getData: $data");
    }
    return data;
  }

  Future<String?> getIsOn() async {
    final SharedPreferences prefs = _preferences;

    final isOn = prefs.getString('dark');

    print("getLang: $isOn");
    return isOn;
  }
}
