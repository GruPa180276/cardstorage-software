import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setIsOn(bool x) async => await _preferences.setBool('but', x);
  static bool getIsOn() => _preferences.getBool('but') ?? true;
}
