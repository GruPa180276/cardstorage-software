import 'package:flutter/material.dart';
import '../color/home_color_values.dart';
import 'package:provider/provider.dart';
import '../themes.dart';

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
            title: const Text("Einstellungen"),
            backgroundColor: settingsCP.getAppBarBackgroundColor(),
            actions: []),
        body: Container(
          padding: EdgeInsets.all(0),
          child: Column(children: [ChangeThemeButtonWidget()]),
        ));
  }
}

class ChangeThemeButtonWidget extends StatefulWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  State<ChangeThemeButtonWidget> createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SwitchListTile(
        value: themeProvider.isDarkMode,
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
        },
        title: Text("Dark Mode", style: const TextStyle(fontSize: 20)));
  }
}
