// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefrences;
  static Future init() async =>
      _prefrences = await SharedPreferences.getInstance();
  //storing data in local storage (token stored as string , data stored as json)
  static void saveData(key, data) async {
    await _prefrences.setString(key, json.encode(data));
  }

  //getting data from local storage
  static Map<String, dynamic> getData(key) {
    if (_prefrences.containsKey(key)) {
      String userPref = _prefrences.getString(key)!;
      return json.decode(userPref) as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  static bool containKey(String key) {
    return _prefrences.containsKey(key);
  }
}
