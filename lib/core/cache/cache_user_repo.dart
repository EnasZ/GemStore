import 'package:shared_preferences/shared_preferences.dart';

class CacheUserRepo {
  static late final SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> login(bool value) async {
    await sharedPreferences.setBool("isLoggedIn", value);
  }

  static isLoggedIn() {
    return sharedPreferences.getBool("isLoggedIn") ?? false;
  }

  static Future<void> logOut() async {
    await sharedPreferences.setBool("isLoggedIn", false);
  }
}
