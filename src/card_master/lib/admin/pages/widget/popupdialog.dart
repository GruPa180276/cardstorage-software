import 'package:flutter/material.dart';

Widget generatePopupDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Text(
      'Karte hinzufügen',
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
    content: Column(
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
        padding: const EdgeInsets.all(10),
        height: 70,
        child: Column(children: [
          SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Abschließen",
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
              ))
        ]),
      ),
    ],
  );
}
