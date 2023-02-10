import 'package:flutter/material.dart';

IconButton generateIconButton(
  BuildContext context,
  IconData icon,
  String route,
) {
  return IconButton(
    onPressed: () {
      Navigator.of(context).pushNamed(route);
    },
    color: Theme.of(context).focusColor,
    icon: Icon(icon),
  );
}
