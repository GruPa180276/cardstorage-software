// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/pop_up/reservate_popup.dart';

Widget buildReservateButton(BuildContext context, String text) {
  return Expanded(
    child: FlatButton(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      shape: Border(
          top: BorderSide(color: ColorSelect.greyBorderColor),
          right: BorderSide(color: ColorSelect.greyBorderColor)),
      color: Colors.transparent,
      splashColor: Colors.black,
      onPressed: () => buildReservatePopUp(context),
      child:
          Text(text, style: TextStyle(color: Theme.of(context).primaryColor)),
    ),
  );
}
