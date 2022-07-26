import 'package:flutter/material.dart';
import '../color/color.dart';

SettingsColorProvder settingsCP = new SettingsColorProvder();

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
