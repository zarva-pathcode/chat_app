import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/auth_data.dart';

class AppData {
  static SharedPreferences? _prefs;
  static AuthData? authData;

  static Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future getUserPreferences() async {
    await initPrefs();
    if (_prefs!.getString("AuthData") == null) {
      return null;
    }
    authData = AuthData.fromJson(_prefs!.getString("AuthData")!);
    return authData;
  }

  static setUserPreferences(
      {String? email, String? name, String? photoUrl, String? status}) async {
    await initPrefs();
    authData = null;
    _prefs!.clear();
    authData = AuthData(
      email: email,
      name: name,
      photoUrl: photoUrl,
      status: status,
    );
    _prefs!.setString("AuthData", jsonEncode(authData!.toMap()));
  }

  static removePrefs() async {
    await initPrefs();
    authData = null;
    return _prefs!.clear();
  }
}
