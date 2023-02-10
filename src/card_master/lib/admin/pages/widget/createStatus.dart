import 'package:flutter/material.dart';

Color colorStatus = Colors.white;
String textStatus = "-";

Table createStatus(
  BuildContext context,
  bool status,
  String name,
  int cardsInStorage,
  int capacity,
) {
  if (status == false) {
    colorStatus = Colors.red;
    textStatus = "Offline";
  } else if (status == true) {
    colorStatus = Colors.green;
    textStatus = "Online";
  }
  return Table(
    columnWidths: {
      0: FractionColumnWidth(0.69),
      1: FractionColumnWidth(0.30),
    },
    children: [
      TableRow(
        children: [
          Text(
            "Status:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            textStatus,
            style: TextStyle(
              fontSize: 20,
              color: colorStatus,
            ),
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
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Karten vorhanden:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            cardsInStorage.toString() + "/" + capacity.toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
    ],
  );
}
