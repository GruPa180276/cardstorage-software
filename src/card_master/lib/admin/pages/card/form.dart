import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';

Widget buildCardForm(
  BuildContext context,
  String buttonText,
  dynamic Function() onPressed,
  GlobalKey<FormState> formKey,
  GenerateListTile nameInput,
  Widget storageSelector,
) {
  return Form(
      key: formKey,
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
        child: Column(
          children: [
            nameInput,
            const SizedBox(
              height: 10,
            ),
            SizedBox(width: double.infinity, child: storageSelector),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(children: [
                SizedBox(
                    height: 60,
                    child: generateButtonRectangle(
                      context,
                      buttonText,
                      onPressed,
                    )),
              ]),
            ),
          ],
        ),
      ));
}
