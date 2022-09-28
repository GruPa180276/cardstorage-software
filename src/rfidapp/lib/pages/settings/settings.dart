import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/pages/login/utils/app_preference.dart';
import 'package:rfidapp/pages/login/login_page.dart';
import 'package:rfidapp/pages/account/account_page.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:app_settings/app_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        body: Container(
          color: Theme.of(context).cardColor,
          child: Table(
            border: TableBorder.all(color: Theme.of(context).dividerColor),
            children: [
              TableRow(children: [
                buildSettingsButton("Benachrichtigungen", Icons.notifications,
                    () {
                  AppSettings.openNotificationSettings();
                }),
              ]),
              TableRow(children: [
                buildSettingsButton("Log-Out", Icons.logout_rounded, () {
                  buildPop();
                }),
              ]),
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
          ),
        ));
  }

  Widget buildSettingsButton(String text, IconData icon, Function function) {
    return ButtonTheme(
      padding: const EdgeInsets.symmetric(
          vertical: 7.0, horizontal: 8.0), //adds padding inside the button
      materialTapTargetSize: MaterialTapTargetSize
          .shrinkWrap, //limits the touch area to the button area
      minWidth: double.infinity, //wraps child's width
      height: 0, //wraps child's height
      child: TextButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).cardColor), // <-- Does not work
          onPressed: () => function(),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 19, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          )),
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

  Future<void> buildPop() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hinweis'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Wollen Sie sich wirklich abmelden?.'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      TextButton(
                        child: const Text('Abbrechen'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  TextButton(
                    child: const Text('Abmelden'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                  ),
                ])
          ],
        );
      },
    );
  }
}
