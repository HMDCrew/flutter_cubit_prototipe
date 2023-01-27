import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  final SharedPreferences localStore;

  LocalStore(this.localStore);

  void setData(String key, dynamic data) {
    localStore.setString(key, json.encode(data));
  }

  String getData(String key) {
    return localStore.getString(key).toString();
  }
}