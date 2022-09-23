import 'package:flutter/material.dart';

Table createUserTable(
  BuildContext context,
  int id,
  String name,
  String mail,
) {
  return Table(
    columnWidths: const <int, TableColumnWidth>{
      0: FixedColumnWidth(140),
      1: FixedColumnWidth(100),
    },
    children: [
      TableRow(
        children: [
          const TableCell(
              child: Text(
            "ID:",
            style: TextStyle(fontSize: 20),
          )),
          TableCell(
              child: Text(
            id.toString(),
            style: TextStyle(fontSize: 20),
          ))
        ],
      ),
      TableRow(
        children: [
          const TableCell(
              child: Text(
            "Name:",
            style: TextStyle(fontSize: 20),
          )),
          TableCell(
              child: Text(
            name,
            maxLines: 1,
            style: TextStyle(fontSize: 20),
          ))
        ],
      ),
      TableRow(
        children: [
          const TableCell(
              child: Text(
            "Mail:",
            style: TextStyle(fontSize: 20),
          )),
          TableCell(
              child: Text(
            mail.toString(),
            maxLines: 1,
            style: TextStyle(fontSize: 20),
          ))
        ],
      ),
    ],
  );
}
