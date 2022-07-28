import 'package:flutter/material.dart';
import '../color/home_color_values.dart';

SettingsColorProvder settingsCP = new SettingsColorProvder();

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Card"),
          backgroundColor: settingsCP.getAppBarBackgroundColor(),
          actions: []),
      body: Column(children: [Text("Test")]),
    );
  }
}
