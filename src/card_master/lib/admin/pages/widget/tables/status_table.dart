import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/generate/table_row.dart';

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
    columnWidths: const {
      0: FractionColumnWidth(0.69),
      1: FractionColumnWidth(0.30),
    },
    children: [
      buildTableRow(context, "Status", textStatus),
      buildTableRow(context, "Name", name),
      buildTableRow(context, "Karten", "$cardsInStorage/$capacity"),
    ],
  );
}
