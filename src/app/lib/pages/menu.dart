import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/provider/themes.dart';
import 'package:app/pages/app_preference.dart';

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
      appBar: AppBar(
        leading: Icon(
          Icons.credit_card,
          size: 30,
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.blueGrey,
        title: Text('Admin Login',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        actions: [
          Icon(Icons.account_box_rounded),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.settings),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.logout),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
          child: Column(
        children: [buildChangeThemeMode(context)],
      )),
    );
  }

  Widget buildChangeThemeMode(BuildContext context) {
    return SwitchListTile(
        activeColor: Theme.of(context).secondaryHeaderColor,
        value: isDark,
        controlAffinity: ListTileControlAffinity.trailing,
        title: Text("Switch Theme Mode"),
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
