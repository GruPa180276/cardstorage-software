import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/iconbutton.dart';

AppBar generateAppBar(BuildContext context) {
  return AppBar(
    leading: generateIconButton(context, Icons.credit_card, "/home"),
    toolbarHeight: 70,
    backgroundColor: Theme.of(context).secondaryHeaderColor,
    title: Text('Admin Login',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).focusColor,
        )),
    actions: [
      generateIconButton(context, Icons.account_box_rounded, "/account"),
      generateIconButton(context, Icons.settings, "/settings"),
      generateIconButton(context, Icons.logout, ""),
    ],
  );
}
