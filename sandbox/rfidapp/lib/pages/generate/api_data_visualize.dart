// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/Widget/views/card_view.dart';

import 'package:intl/intl.dart';

class ListCards {
  static late var listOfTypes;
  static DateTime date = DateTime(2000, 1, 12, 12);
  static BuildContext? buildContext;
  static DateTime? vonTime;
  static DateTime? bisTime;
  static TextEditingController vonTextEdidtingcontroller =
      TextEditingController();
  static TextEditingController bisTextEdidtingcontroller =
      TextEditingController();

  //@TODO and voidCallback
  static Widget build(BuildContext context) {
    buildContext = context;
    return FutureBuilder<List<Cards>>(
      future: listOfTypes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final users = snapshot.data!;
          return cardsView(users, context);
        } else {
          return Text("${snapshot.error}");
        }
      },
    );
  }
}
