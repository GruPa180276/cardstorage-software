import 'package:flutter/material.dart';

Table createUserTable(
  BuildContext context,
  String email,
  bool priviledged,
) {
  email = email.split("@")[0];

  return Table(
    columnWidths: {
      0: FractionColumnWidth(0.34),
      1: FractionColumnWidth(0.65),
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
            "Berechtigt:",
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
