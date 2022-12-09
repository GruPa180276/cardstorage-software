import 'package:flutter/material.dart';

Table createCardTable(
  BuildContext context,
  int id,
  String name,
  int storageId,
  bool isAvailable,
) {
  Color color = Colors.green;
  if (isAvailable == false) {
    color = Colors.red;
  }
  return Table(columnWidths: {
    0: FractionColumnWidth(0.49),
    1: FractionColumnWidth(0.5)
  }, children: [
    TableRow(
      children: [
        Text(
          "ID:",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          id.toString(),
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.right,
        )
      ],
    ),
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
          "StorageId:",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          storageId.toString(),
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
          style: TextStyle(
            fontSize: 20,
            color: color,
          ),
          textAlign: TextAlign.right,
        )
      ],
    )
  ]);
}
