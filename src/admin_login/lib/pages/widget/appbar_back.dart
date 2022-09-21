import 'package:admin_login/pages/widget/iconbutton.dart';
import 'package:flutter/material.dart';

AppBar generateAppBarBack(BuildContext context) {
  return AppBar(
    leading: generateIconButton(context, Icons.arrow_back, "/home"),
    toolbarHeight: 70,
    backgroundColor: Theme.of(context).secondaryHeaderColor,
    title: Text('Admin Login',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).focusColor,
        )),
  );
}
