import 'package:flutter/material.dart';

Widget generateReloadButton(BuildContext context, Function clear) {
  return FloatingActionButton(
    foregroundColor: Theme.of(context).focusColor,
    backgroundColor: Theme.of(context).secondaryHeaderColor,
    onPressed: () {
      clear();
    },
    child: Icon(
      Icons.clear,
    ),
  );
}
