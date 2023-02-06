import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

Table createReservationTable(
  BuildContext context,
  String card,
  String email,
  int since,
  int until,
  int returnedAt,
) {
  String back = "";

  if (returnedAt < 0) {
    back = "-";
  } else {
    back = DateFormat('kk:mm, dd-MM-yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(returnedAt * 1000));
  }
  return Table(
    columnWidths: {
      0: FractionColumnWidth(0.39),
      1: FractionColumnWidth(0.60),
    },
    children: [
      TableRow(
        children: [
          Text(
            "Karte:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            card,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Email:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            email.split('@')[0],
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Seit:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            DateFormat('kk:mm, dd-MM-yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(since * 1000)),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Bis:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            DateFormat('kk:mm, dd-MM-yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(until * 1000)),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
      TableRow(
        children: [
          Text(
            "Zurück:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            back,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          )
        ],
      ),
    ],
  );
}
