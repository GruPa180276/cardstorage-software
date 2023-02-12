import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/card/card_table_row.dart';

Table createCardTable(
  BuildContext context,
  String cardName,
  String storageName,
  int accessed,
  String isAvailable,
) {
  return Table(columnWidths: const {
    0: FractionColumnWidth(0.49),
    1: FractionColumnWidth(0.50)
  }, children: [
    buildTableRow(context, "Name", cardName),
    buildTableRow(context, "Storage", storageName),
    buildTableRow(context, "Verwendungen", accessed),
    buildTableRow(context, "Verfügbar", isAvailable),
  ]);
}
