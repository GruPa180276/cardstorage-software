import 'package:admin_login/provider/types/storages.dart';
import 'package:flutter/material.dart';

Table createStorageTable(
  BuildContext context,
  String name,
  String location,
  int maxCardCount,
  bool focus,
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
            "Kapazität:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            maxCardCount.toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Focus:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            focus.toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
    ],
  );
}
