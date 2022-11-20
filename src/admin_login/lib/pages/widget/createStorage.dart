import 'package:flutter/material.dart';

Table createStorageTable(
  BuildContext context,
  int id,
  String location,
  int maxCardCount,
) {
  return Table(
    defaultColumnWidth: IntrinsicColumnWidth(),
    children: [
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
                "Ort:",
                style: TextStyle(fontSize: 20),
              )),
              Spacer(),
              TableCell(
                  child: Text(
                location.toString(),
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
                "Anzahl Karten:",
                style: TextStyle(fontSize: 20),
              )),
              Spacer(),
              TableCell(
                  child: Text(
                maxCardCount.toString(),
                style: TextStyle(fontSize: 20),
              ))
            ],
          )
        ],
      ),
    ],
  );
}
