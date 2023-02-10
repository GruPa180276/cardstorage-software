import 'package:flutter/material.dart';

Table createCardTable(
  BuildContext context,
  String name,
  int accessed,
  bool isAvailable,
) {
  return Table(columnWidths: {
    0: FractionColumnWidth(0.39),
    1: FractionColumnWidth(0.60)
  }, children: [
    TableRow(
      children: [
        Text(
          "Name:",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.right,
        )
      ],
    ),
    TableRow(
      children: [
        Text(
          "Verwendet:",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          accessed.toString(),
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.right,
        )
      ],
    ),
    TableRow(
      children: [
        Text(
          "Verfügbar:",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          isAvailable.toString(),
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.right,
        )
      ],
    ),
  ]);
}
