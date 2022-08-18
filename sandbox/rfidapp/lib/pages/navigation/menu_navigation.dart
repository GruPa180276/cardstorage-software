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
    final name = "Mustermann";
    final email = "example@gmail.com";

    return Drawer(
        child: Material(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          buildHeader(
              name: name,
              email: email,
              onClicked: () => selectedItem(context, 5)),
          const SizedBox(height: 10),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text("Theme", style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    width: 146,
                  ),
                  buildChangeThemeMode(context)
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          buildMenuItem(
              text: "Einstellungen",
              icon: Icons.settings,
              onclicked: () => selectedItem(context, 1)),
          const SizedBox(height: 10),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 10),
          buildMenuItem(
              text: "Home",
              icon: Icons.home,
              onclicked: () => selectedItem(context, 2)),
          const SizedBox(height: 16),
          buildMenuItem(
              text: "Cards",
              icon: Icons.sd_card,
              onclicked: () => selectedItem(context, 3)),
          const SizedBox(height: 16),
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

  Widget buildHeader({
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 40, 0, 16),
          child: Row(
            children: [
              //CircleAvatar(radius: 30, backgroundImage: Icons.account_box),
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.account_box,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      );
}
