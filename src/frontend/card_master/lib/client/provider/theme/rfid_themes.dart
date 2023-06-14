import 'package:card_master/client/config/palette.dart';
import 'package:flutter/material.dart';

class RifdAppThemes {
  //whitemode
  static get darkTheme => ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        secondaryHeaderColor: ColorSelect.blueAccent,
        dividerColor: ColorSelect.darkBorder,
        cardColor: ColorSelect.darkCardColor,
        focusColor: Colors.white,
        colorScheme: const ColorScheme.dark()
            .copyWith(primary: ColorSelect.blueAccent)
            .copyWith(background: Colors.black),
      );

  //darkmode
  static get lightTheme => ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: ColorSelect.lightBgColor,
        primaryColor: Colors.black,
        secondaryHeaderColor: ColorSelect.blueAccent,
        dividerColor: ColorSelect.lightBorder,
        cardColor: ColorSelect.lightCardColor,
        focusColor: Colors.white,
        colorScheme: const ColorScheme.light()
            .copyWith(primary: ColorSelect.blueAccent)
            .copyWith(background: Colors.black),
      );
}
