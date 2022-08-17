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
            title: const Text("App Info"),
            backgroundColor: settingsCP.getAppBarBackgroundColor(),
            actions: []),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Text(
                "Diese App wurde als Diplomarbeit für das Litec Card Storage Projekt erstellt. \n\nDiese App wurde von Zöchmann Benedikt erstellt.",
                style: const TextStyle(fontSize: 20))
          ]),
        ));
  }
}
