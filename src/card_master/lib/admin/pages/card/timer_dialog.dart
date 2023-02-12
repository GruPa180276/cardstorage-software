import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/card/timer.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/types/cards.dart';

Widget buildTimerdialog(
  BuildContext context,
  Cards newEntry,
) {
  return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Karte anlegen',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bitte Karte an den Scanner halten ...",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
              child: TimerAddCard(
            name: newEntry.name,
          )),
        ],
      ),
      actions: [
        generateButtonRectangle(
          context,
          "Abbrechen",
          () {
            Navigator.of(context).pop();
          },
        )
      ]);
}
