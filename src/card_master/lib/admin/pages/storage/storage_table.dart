import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/card/card_table_row.dart';

Table createStorageTable(
  BuildContext context,
  Storages storage,
  String focusState,
) {
  return Table(
    columnWidths: const {
      0: FractionColumnWidth(0.59),
      1: FractionColumnWidth(0.40),
    },
    children: [
      buildTableRow(context, "Name", storage.name),
      buildTableRow(context, "Ort", storage.location),
      buildTableRow(context, "Karten", storage.numberOfCards),
      buildTableRow(context, "Focus", focusState),
    ],
  );
}
