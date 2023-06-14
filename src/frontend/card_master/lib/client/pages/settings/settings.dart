// ignore_for_file: use_build_context_synchronously

import 'package:card_master/client/pages/widgets/widget/app_bar.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_master/client/domain/persistent/app_preferences.dart';
import 'package:card_master/client/pages/account/account_page.dart';
import 'package:card_master/client/domain/authentication/user_session_manager.dart';
import 'package:card_master/client/provider/theme/theme_provider.dart';
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
    var columnHeight = 5.0.hs;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10.0.hs), //height of appbar
          child: const CustomAppBar(title: "Einstellungen"),
        ),
        body: Container(
          color: Theme.of(context).cardColor,
          child: Table(
            border: TableBorder.all(
                color: Theme.of(context).dividerColor, width: 0.3.hs),
            children: [
              TableRow(children: [
                buildSettingsButton("Benachrichtigungen", Icons.notifications,
                    () {
                  AppSettings.openNotificationSettings();
                }),
              ]),
              TableRow(children: [
                buildSettingsButton("Ausloggen", Icons.logout_rounded, () {
                  buildPop();
                }),
              ]),
              TableRow(children: [
                buildSettingsButton("Account", Icons.person, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AccountPage()));
                }),
              ]),
              TableRow(children: [
                Container(
                  height: columnHeight,
                  padding: EdgeInsets.symmetric(horizontal: 2.0.ws),
                  color: Theme.of(context).cardColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.mode,
                            size: 3.4.hs,
                          ),
                          SizedBox(
                            width: 5.0.ws,
                          ),
                          Text(' Dark-Mode',
                              style: TextStyle(
                                  fontSize: 3.0.fs,
                                  color: Theme.of(context).primaryColor)),
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
      materialTapTargetSize: MaterialTapTargetSize
          .shrinkWrap, //limits the touch area to the button area
      minWidth: double.infinity, //wraps child's width
      height: 0, //wraps child's height
      child: TextButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).cardColor), // <-- Does not work
          onPressed: () => function(),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 1.0.ws,
                ),
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 3.4.hs,
                ),
                SizedBox(
                  width: 5.0.ws,
                ),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 3.0.fs, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildChangeThemeMode(BuildContext context) {
    return Transform.scale(
      scale: 0.15.hs,
      child: Switch(
          activeColor: Theme.of(context).secondaryHeaderColor,
          value: isDark,
          onChanged: (value) {
            final provider = Provider.of<ThemeProvider>(context, listen: false);
            isDark = value;
            setState(() {
              provider.toggleTheme(value);
            });
          }),
    );
  }

  Future<void> buildPop() async {
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
                    onPressed: () async {
                      UserSessionManager.logout(context);
                    },
                  ),
                ])
          ],
        );
      },
    );
  }
}
