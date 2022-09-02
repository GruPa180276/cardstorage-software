import 'package:flutter/material.dart';
import 'package:app/config/theme/palette.dart';
import 'package:app/config/theme/app_preference.dart';

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
        colorScheme:
            const ColorScheme.dark().copyWith(primary: ColorSelect.blueAccent),

        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        backgroundColor: Colors.black,
        secondaryHeaderColor: ColorSelect.blueAccent,
        focusColor: Colors.white,

        //new
        dividerColor: ColorSelect.blueAccent,
        cardColor: ColorSelect.darkCardColor,
      );

  static get lightTheme => ThemeData(
        fontFamily: 'Kanit',
        colorScheme:
            const ColorScheme.light().copyWith(primary: ColorSelect.blueAccent),

        scaffoldBackgroundColor: ColorSelect.lightBgColor,
        primaryColor: Colors.black,
        backgroundColor: Colors.black,
        secondaryHeaderColor: ColorSelect.blueAccent,
        focusColor: Colors.white,

        //new
        dividerColor: ColorSelect.lightBorder,
        cardColor: ColorSelect.lightCardColor,
      );
}
