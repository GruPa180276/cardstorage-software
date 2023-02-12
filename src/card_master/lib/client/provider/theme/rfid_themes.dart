import 'package:card_master/admin/config/theme/palette.dart';
import 'package:flutter/material.dart';

class RifdAppThemes {
  //whitemode
  static get darkTheme => ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: Colors.black,
        colorScheme:
            const ColorScheme.dark().copyWith(primary: ColorSelect.blueAccent),
        primaryColor: Colors.white,
        secondaryHeaderColor: ColorSelect.blueAccent,
        dividerColor: ColorSelect.darkBorder,
        cardColor: ColorSelect.darkCardColor,
      );

  //darkmode
  static get lightTheme => ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: ColorSelect.lightBgColor,
        colorScheme:
            const ColorScheme.light().copyWith(primary: ColorSelect.blueAccent),
        primaryColor: Colors.black,
        secondaryHeaderColor: ColorSelect.blueAccent,
        dividerColor: ColorSelect.lightBorder,
        cardColor: ColorSelect.lightCardColor,
      );
}
