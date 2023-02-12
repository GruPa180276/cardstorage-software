import 'package:flutter/material.dart';

Widget buildAlertDialog(
  BuildContext context,
  String heading,
  String infoText,
  List<Widget> action,
) {
  return AlertDialog(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Text(
      heading,
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          infoText,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ],
    ),
    actions: action,
  );
}
