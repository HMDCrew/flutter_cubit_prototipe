import 'package:shared_preferences/shared_preferences.dart';

const cachedToken = 'CACHED_TOKEN';

class LocalStore {
  final SharedPreferences sharedPreferences;

  LocalStore(this.sharedPreferences);

  delete(String token) {
    sharedPreferences.remove(cachedToken);
  }

  Future<String> fetch() {
    final tokenStr = sharedPreferences.getString(cachedToken);

    return (tokenStr != null ? Future.value(tokenStr) : Future.value(''));
  }

  Future save(String token) {
    return sharedPreferences.setString(cachedToken, token);
  }
}
