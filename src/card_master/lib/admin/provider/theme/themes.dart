import 'package:flutter/material.dart';
import 'package:card_master/admin/config/theme/palette.dart';
import 'package:card_master/admin/config/theme/app_preference.dart';

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
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        secondaryHeaderColor: ColorSelect.blueAccent,
        focusColor: Colors.white,
        dividerColor: ColorSelect.blueAccent,
        cardColor: ColorSelect.darkCardColor,
        navigationBarTheme:
            const NavigationBarThemeData(backgroundColor: Colors.black),
        colorScheme: const ColorScheme.dark()
            .copyWith(primary: ColorSelect.blueAccent)
            .copyWith(background: Colors.black),
      );

  static get lightTheme => ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: ColorSelect.lightBgColor,
        primaryColor: Colors.black,
        secondaryHeaderColor: ColorSelect.blueAccent,
        focusColor: Colors.white,
        dividerColor: ColorSelect.lightBorder,
        cardColor: ColorSelect.lightCardColor,
        colorScheme: const ColorScheme.light()
            .copyWith(primary: ColorSelect.blueAccent)
            .copyWith(background: Colors.black),
      );
}
