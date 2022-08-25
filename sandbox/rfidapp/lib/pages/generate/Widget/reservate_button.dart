// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/pop_up/reservate_popup.dart';
import 'package:rfidapp/provider/types/cards.dart';

Widget buildReservateButton(BuildContext context, String text, Cards cards) {
  return Expanded(
    child: FlatButton(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      shape: Border(
          top: BorderSide(color: ColorSelect.greyBorderColor),
          right: BorderSide(color: ColorSelect.greyBorderColor)),
      color: Colors.transparent,
      splashColor: Colors.black,
      onPressed: () {
        buildReservatePopUp(context, cards);
      },
      child:
          Text(text, style: TextStyle(color: Theme.of(context).primaryColor)),
    ),
  );
}
