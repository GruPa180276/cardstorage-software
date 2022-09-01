import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/config/themes.dart';
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
          toolbarHeight: 125,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text("Einstellungen",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor)),
        ),
        body: Table(
          border: TableBorder.all(color: Theme.of(context).dividerColor),
          children: [
            TableRow(children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Theme.of(context).cardColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.mode),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Dark-Mode',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: buildChangeThemeMode(context)),
                  ],
                ),
              )
            ])
          ],
        ));
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
