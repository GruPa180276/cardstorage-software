import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/pages/widget/generate/table_row.dart';

Table createUserTable(
  BuildContext context,
  Users users,
  String privilegedState,
) {
  return Table(
    columnWidths: const {
      0: FractionColumnWidth(0.29),
      1: FractionColumnWidth(0.70),
    },
    children: [
      buildTableRow(context, "Mail", users.email.split("@")[0]),
      buildTableRow(context, "Domain", users.email.split("@")[1]),
      buildTableRow(context, "Admin", privilegedState),
    ],
  );
}
