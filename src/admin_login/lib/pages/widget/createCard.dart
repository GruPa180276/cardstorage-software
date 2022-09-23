import 'package:flutter/material.dart';

Table createCardTable(
  BuildContext context,
  int id,
  String name,
  int storageID,
  bool isAvailable,
) {
  Color color = Colors.green;
  if (isAvailable == false) {
    color = Colors.red;
  }
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
            "StorageId:",
            style: TextStyle(fontSize: 20),
          )),
          TableCell(
              child: Text(
            storageID.toString(),
            style: TextStyle(fontSize: 20),
          ))
        ],
      ),
      TableRow(
        children: [
          const TableCell(
              child: Text(
            "Verfügbar:",
            style: TextStyle(fontSize: 20),
          )),
          TableCell(
            child: Text(
              isAvailable.toString(),
              style: TextStyle(fontSize: 20, color: color),
            ),
          )
        ],
      )
    ],
  );
}
