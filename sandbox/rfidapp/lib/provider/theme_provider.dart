import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/Login/Utils/app_preference.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode =
      AppPreferences.getIsOn() ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static get darkTheme => ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: const ColorScheme.dark()
          .copyWith(primary: const Color.fromARGB(255, 1, 216, 89)),
      primaryColor: Colors.white);

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light()
          .copyWith(primary: Color.fromARGB(255, 1, 216, 89)),
      primaryColor: Colors.black);
}
