// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/pop_up/reservate_popup.dart';
import 'package:rfidapp/provider/types/cards.dart';

Widget buildReservateButton(BuildContext context, String text, Cards cards) {
  return Expanded(
    child: DecoratedBox(
               decoration: BoxDecoration(
    border: Border(
      right: BorderSide(color: Theme.of(context).cardColor),
      left: BorderSide(color: Theme.of(context).cardColor),
    ),
  ),
              child: TextButton(
                style: ElevatedButton.styleFrom(primary: Colors.black.withOpacity(0)), // <-- Does not work
                onPressed: () {
        buildReservatePopUp(context, cards);
                },
                child: Text(text,
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
  );
}
