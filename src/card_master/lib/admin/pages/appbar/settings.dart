import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:card_master/admin/provider/theme/themes.dart';
import 'package:card_master/admin/config/theme/app_preference.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Settings> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = AppPreferences.getIsOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Einstellungen",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          actions: []),
      body: Container(
          child: Column(
        children: [buildChangeThemeMode(context)],
      )),
    );
  }

  Widget buildChangeThemeMode(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                value: isDark,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(
                  "Switch Theme Mode",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onChanged: (value) async {
                  await AppPreferences.setIsOn(value);
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  isDark = value;
                  setState(() {
                    provider.toggleTheme(value);
                  });
                })));
  }
}
