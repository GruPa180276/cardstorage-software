import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:card_master/admin/pages/card/card_table_row.dart';
import 'package:card_master/admin/provider/types/reservations.dart';

Table createReservationTable(
  BuildContext context,
  ReservationOfCards cardReservation,
  String cardName,
  String back,
) {
  return Table(
    columnWidths: const {
      0: FractionColumnWidth(0.39),
      1: FractionColumnWidth(0.60),
    },
    children: [
      buildTableRow(context, "Name", cardName),
      buildTableRow(context, "Mail", cardReservation.users.email.split("@")[0]),
      buildTableRow(
          context, "Domain", cardReservation.users.email.split("@")[1]),
      buildTableRow(
          context,
          "Seit",
          DateFormat('kk:mm, dd-MM-yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                  cardReservation.since * 1000))),
      buildTableRow(
          context,
          "Bis",
          DateFormat('kk:mm, dd-MM-yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                  cardReservation.until * 1000))),
      buildTableRow(context, "Zurück", back),
    ],
  );
}
