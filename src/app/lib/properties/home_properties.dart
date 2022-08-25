import 'package:flutter/material.dart';

class HomeTextProvider {
  String getAppTitle() {
    return "Admin-Login";
  }

  String getDrawerSettingsTabName() {
    return "Settings";
  }

  String getDrawerAppInfoTabName() {
    return "AppInfo";
  }

  String getDrawerIconPath() {
    return "img/splashscreen.jpg";
  }
}

class HomeColorProvider {
  MaterialColor getHeaderColor() {
    return Colors.blueGrey;
  }

  Color getDrawerHeaderColor() {
    return Colors.blueGrey;
  }

  Color getTabBarLabelColor() {
    return Colors.blueGrey;
  }

  Color getDrawerHeaderDividerColor() {
    return Colors.blueGrey;
  }

  Color getDrawerColor() {
    return Colors.blueGrey;
  }
}

class SettingsColorProvder {
  Color getAppBarBackgroundColor() {
    return Colors.blueGrey;
  }
}

class AppInfoColorProvder {
  Color getAppBarBackgroundColor() {
    return Colors.blueGrey;
  }
}
