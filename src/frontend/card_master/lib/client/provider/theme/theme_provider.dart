import 'package:flutter/material.dart';

import 'package:card_master/client/domain/persistent/app_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode _themeMode;

  ThemeProvider() {
    _themeMode = AppPreferences.getIsOn() ? ThemeMode.dark : ThemeMode.light;
  }
  void toggleTheme(bool isOn) async {
    await AppPreferences.setIsOn(isOn);
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    return _themeMode;
  }
}
