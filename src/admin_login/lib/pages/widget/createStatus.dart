import 'package:flutter/material.dart';

Color colorError = Colors.white;
Color colorStatus = Colors.white;
Color colorCardsOverDate = Colors.white;
String textStatus = "-";

Table createStatus(
  BuildContext context,
  bool status,
  int cardsInStorage,
  int capacity,
  int numOfErrors,
  int cardsOverDate,
) {
  if (status == false) {
    colorStatus = Colors.red;
    textStatus = "Offline";
  } else if (status == true) {
    colorStatus = Colors.green;
    textStatus = "Online";
  }

  if (numOfErrors > 0) {
    colorError = Colors.red;
  } else if (numOfErrors == 0) {
    colorError = Colors.green;
  }

  if (cardsOverDate > 0) {
    colorCardsOverDate = Colors.red;
  } else if (cardsOverDate == 0) {
    colorCardsOverDate = Colors.green;
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
      TableRow(
        children: [
          Text(
            "Errors:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            numOfErrors.toString(),
            style: TextStyle(
              fontSize: 20,
              color: colorError,
            ),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Karten überzogen:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            cardsOverDate.toString(),
            style: TextStyle(
              fontSize: 20,
              color: colorCardsOverDate,
            ),
            textAlign: TextAlign.right,
          )
        ],
      ),
    ],
  );
}
