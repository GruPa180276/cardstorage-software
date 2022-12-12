import 'package:flutter/material.dart';

Table createStorageTable(
  BuildContext context,
  int id,
  String name,
  int location,
  int maxCardCount,
) {
  return Table(
    columnWidths: {
      0: FractionColumnWidth(0.59),
      1: FractionColumnWidth(0.40),
    },
    children: [
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
            name.toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Ort:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            location.toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Anzahl Karten:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            maxCardCount.toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
    ],
  );
}
