import 'package:card_master/admin/provider/types/cards.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/generate/table_row.dart';

Table createCardTable(
  BuildContext context,
  Cards card,
  String storageName,
  String isAvailable,
) {
  return Table(columnWidths: const {
    0: FractionColumnWidth(0.49),
    1: FractionColumnWidth(0.50)
  }, children: [
    buildTableRow(context, "Name", card.name),
    buildTableRow(context, "Storage", storageName),
    buildTableRow(context, "Verwendungen", card.accessed),
    buildTableRow(context, "Verfügbar", isAvailable),
  ]);
}
