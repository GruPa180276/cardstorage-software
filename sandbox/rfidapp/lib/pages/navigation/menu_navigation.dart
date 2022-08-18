import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rfidapp/pages/home/home_page.dart';
import 'package:rfidapp/pages/login/login_page.dart';
import 'package:rfidapp/pages/cards/cards_page.dart';
import 'package:rfidapp/pages/Login/Utils/app_preference.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class MenuNavigationDrawer extends StatefulWidget {
  @override
  State<MenuNavigationDrawer> createState() => _MenuNavigationDrawerState();
}

class _MenuNavigationDrawerState extends State<MenuNavigationDrawer> {
  late bool isDark;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDark = AppPreferences.getIsOn();
  }

  @override
  Widget build(BuildContext context) {
    final name = "mustermann@gmail.com";
    final email = "example@gmail.com";

    return Drawer(
        child: Material(
      child: ListView(
        // buildHeader(
        //   name:name,
        //   email:email
        // )
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 48),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text("DarkMode",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontFamily: "Lato")),
                  SizedBox(
                    width: 125,
                  ),
                  buildChangeThemeMode(context)
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          buildMenuItem(
              text: "Account",
              icon: Icons.account_box,
              onclicked: () => selectedItem(context, 0)),
          const SizedBox(height: 16),
          buildMenuItem(
              text: "Einstellungen",
              icon: Icons.settings,
              onclicked: () => selectedItem(context, 1)),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).primaryColor),
          const SizedBox(height: 24),
          buildMenuItem(
              text: "Home",
              icon: Icons.home,
              onclicked: () => selectedItem(context, 2)),
          const SizedBox(height: 24),
          buildMenuItem(
              text: "Cards",
              icon: Icons.sd_card,
              onclicked: () => selectedItem(context, 3)),
          const SizedBox(height: 24),
          buildMenuItem(
              text: "Home",
              icon: Icons.info,
              onclicked: () => selectedItem(context, 4)),
        ],
      ),
    ));
  }

  buildMenuItem(
      {required String text,
      required IconData icon,
      required VoidCallback? onclicked}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onclicked,
    );
  }

  selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
        break;

      case 1:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CardPage()));
        break;
    }
  }

  Widget buildChangeThemeMode(BuildContext context) {
    return Switch(
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

  buildHeader({required String name, required String email}) {}
}
