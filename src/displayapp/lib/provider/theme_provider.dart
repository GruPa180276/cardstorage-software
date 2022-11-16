import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/app_preferences.dart';

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
        colorScheme:
            const ColorScheme.dark().copyWith(primary: ColorSelect.blueAccent),
        primaryColor: Colors.white,
        secondaryHeaderColor: ColorSelect.blueAccent,

        //new
        dividerColor: ColorSelect.darkBorder,
        cardColor: ColorSelect.darkCardColor,
      );

  static get lightTheme => ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: ColorSelect.lightBgColor,
        colorScheme:
            const ColorScheme.light().copyWith(primary: ColorSelect.blueAccent),
        primaryColor: Colors.black,
        secondaryHeaderColor: ColorSelect.blueAccent,
        //new
        dividerColor: ColorSelect.lightBorder,
        cardColor: ColorSelect.lightCardColor,
      );
}


//accentColor:blue, 