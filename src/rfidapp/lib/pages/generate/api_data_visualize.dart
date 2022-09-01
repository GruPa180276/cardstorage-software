// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';

import 'package:rfidapp/pages/generate/Widget/views/card_view.dart';

class ApiVisualizer {
  // ignore: prefer_typing_uninitialized_variables
  //TODO make with required
  static late var listOfTypes;
  static late var searchString = '';

  static Widget build(BuildContext context, String site) {
    return FutureBuilder<List<Cards>>(
      future: listOfTypes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final users = snapshot.data!;

          switch (site) {
            case "cards":
              return cardsView(users, context, site, searchString);
            case "reservation":
              return cardsView(users, context, site, searchString);
          }
          return const Text('Error Type not valid');
        } else {
          return Text("${snapshot.error}");
        }
      },
    );
  }
}

  //@TODO and voidCallback


