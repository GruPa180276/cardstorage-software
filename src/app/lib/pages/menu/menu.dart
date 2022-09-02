import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/provider/theme/themes.dart';
import 'package:app/config/theme/app_preference.dart';

import '../Widget/appbar.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Menu> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = AppPreferences.getIsOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      body: Container(
          child: Column(
        children: [buildChangeThemeMode(context)],
      )),
    );
  }

  Widget buildChangeThemeMode(BuildContext context) {
    return SwitchListTile(
        activeColor: Theme.of(context).primaryColor,
        value: isDark,
        controlAffinity: ListTileControlAffinity.trailing,
        title: Text(
          "Switch Theme Mode",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onChanged: (value) async {
          await AppPreferences.setIsOn(value);
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          isDark = value;
          setState(() {
            provider.toggleTheme(value);
          });
        });
  }
}
