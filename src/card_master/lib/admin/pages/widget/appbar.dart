import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/iconbutton.dart';

AppBar generateAppBar(BuildContext context) {
  return AppBar(
    leading: Icon(Icons.credit_card),
    toolbarHeight: 70,
    backgroundColor: Theme.of(context).secondaryHeaderColor,
    title: Text('Admin',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).focusColor,
        )),
    actions: [
      generateIconButton(context, Icons.settings, "/settings"),
      generateIconButton(context, Icons.bookmark, "/reservations"),
      generateIconButton(context, Icons.account_box, "/users"),
      generateIconButton(context, Icons.logout, ""),
    ],
  );
}
