import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/app_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode =
      AppPreferences.getIsOn() ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    return _themeMode;
  }
}
