import 'package:flutter/material.dart';

Table createUserTable(
  BuildContext context,
  String email,
  bool priviledged,
) {
  email = email.split("@")[0];

  return Table(
    columnWidths: {
      0: FractionColumnWidth(0.39),
      1: FractionColumnWidth(0.60),
    },
    children: [
      TableRow(
        children: [
          Text(
            "Name:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            email.toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Priviledged:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            priviledged.toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
    ],
  );
}
