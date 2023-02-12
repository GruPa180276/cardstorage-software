import 'package:flutter/material.dart';

TableRow buildTableRow(
  BuildContext context,
  String labelName,
  dynamic value,
) {
  return TableRow(
    children: [
      Text(
        labelName,
        style: const TextStyle(fontSize: 20),
      ),
      Text(
        value.toString(),
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.right,
      )
    ],
  );
}
