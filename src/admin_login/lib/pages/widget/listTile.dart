import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

ListTile generateListTile(
    BuildContext context, String labelText, IconData icon, String regExp) {
  return ListTile(
    leading: Icon(icon, color: Theme.of(context).primaryColor),
    title: TextField(
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(regExp))],
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          )),
    ),
  );
}
