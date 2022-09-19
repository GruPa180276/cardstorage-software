import 'package:flutter/material.dart';

import 'package:admin_login/config/theme/app_preference.dart';

import 'package:admin_login/pages/widget/appbar.dart';

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
        children: [],
      )),
    );
  }
}
