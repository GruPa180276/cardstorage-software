import 'package:flutter/material.dart';

AppBar generateAppBar(BuildContext context) {
  return AppBar(
    leading: Icon(
      Icons.credit_card,
      size: 30,
    ),
    toolbarHeight: 70,
    backgroundColor: Theme.of(context).secondaryHeaderColor,
    title: Text('Admin Login',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).focusColor,
        )),
    actions: [
      Icon(
        Icons.account_box_rounded,
        color: Theme.of(context).focusColor,
      ),
      SizedBox(
        width: 20,
      ),
      Icon(
        Icons.settings,
        color: Theme.of(context).focusColor,
      ),
      SizedBox(
        width: 20,
      ),
      Icon(
        Icons.logout,
        color: Theme.of(context).focusColor,
      ),
      SizedBox(
        width: 10,
      ),
    ],
  );
}
