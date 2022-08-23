// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';

import 'package:rfidapp/pages/generate/Widget/views/card_view.dart';

class ApiVisualizer {
  // ignore: prefer_typing_uninitialized_variables
  static late var listOfTypes;
  static Widget build(BuildContext context) {
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

  //@TODO and voidCallback


