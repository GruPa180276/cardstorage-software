import 'package:flutter/material.dart';

Table createStorageTable(
  BuildContext context,
  int id,
  String location,
  int maxCardCount,
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
            "Ort:",
            style: TextStyle(fontSize: 20),
          )),
          TableCell(
              child: Text(
            location,
            maxLines: 1,
            style: TextStyle(fontSize: 20),
          ))
        ],
      ),
      TableRow(
        children: [
          const TableCell(
              child: Text(
            "Anzahl Karten:",
            style: TextStyle(fontSize: 20),
          )),
          TableCell(
              child: Text(
            maxCardCount.toString(),
            maxLines: 1,
            style: TextStyle(fontSize: 20),
          ))
        ],
      ),
    ],
  );
}
