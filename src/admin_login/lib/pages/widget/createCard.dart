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
  return Table(defaultColumnWidth: IntrinsicColumnWidth(), children: [
    TableRow(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            const TableCell(
                child: Text(
              "ID:",
              style: TextStyle(fontSize: 20),
            )),
            Spacer(),
            TableCell(
                child: Text(
              id.toString(),
              style: TextStyle(fontSize: 20),
            ))
          ],
        )
      ],
    ),
    TableRow(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            const TableCell(
                child: Text(
              "Name:",
              style: TextStyle(fontSize: 20),
            )),
            TableCell(
                child: Text(
              name,
              style: TextStyle(fontSize: 20),
            ))
          ],
        )
      ],
    ),
    TableRow(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            const TableCell(
                child: Text(
              "StorageID:",
              style: TextStyle(fontSize: 20),
            )),
            TableCell(
                child: Text(
              storageID.toString(),
              style: TextStyle(fontSize: 20),
            ))
          ],
        )
      ],
    ),
    TableRow(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            const TableCell(
                child: Text(
              "Verfügbar:",
              style: TextStyle(fontSize: 20),
            )),
            TableCell(
                child: Text(
              isAvailable.toString(),
              style: TextStyle(
                fontSize: 20,
                color: color,
              ),
            ))
          ],
        )
      ],
    )
  ]);
}
