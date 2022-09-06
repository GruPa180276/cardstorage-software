import 'package:flutter/material.dart';

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Text(
      'Karte hinzufügen',
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Gehen Sie bitte zum Kartenlesegerät am Kartenautomaten und halte Sie die jeweilige Karte vor den Scanner ...",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ],
    ),
    actions: <Widget>[
      Container(
        padding: EdgeInsets.all(10),
        height: 70,
        child: Column(children: [
          SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // ToDo: Implment Call, to start the Scanner
                },
                child: Text(
                  "Abschließen",
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).secondaryHeaderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ))
        ]),
      ),
    ],
  );
}
