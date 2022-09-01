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
        height: 40,
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).cardColor,
        child: Row(
          children: [
            Icon(Icons.mode),
            SizedBox(
              width: 10,
            ),
            Text('Dark-Mode',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
            Align(
                alignment: Alignment.centerRight,
                child: buildChangeThemeMode(context)),
          ],
        ),
      ),
    );
  }

  Widget buildChangeThemeMode(BuildContext context) {
    return Switch(
        activeColor: Theme.of(context).secondaryHeaderColor,
        value: isDark,
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
