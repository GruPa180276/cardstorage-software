import 'dart:convert';

import 'package:card_master/admin/provider/middelware.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/card/alert_dialog.dart';

class TimerAddCard extends StatefulWidget {
  final String? name;

  const TimerAddCard({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  TimerAddCardState createState() => TimerAddCardState();
}

class TimerAddCardState extends State<TimerAddCard> {
  final interval = const Duration(seconds: 1);
  int timerMaxSeconds = 20;
  int currentSeconds = 0;

  Cards card = Cards(
    name: "",
    storage: "",
    position: 0,
    accessed: 0,
    available: false,
    reader: "",
  );

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  void getCard() async {
    var response = await Data.checkAuthorization(
        context: context,
        function: getCardByName,
        args: {"name": widget.name, 'data': []});
    var temp = jsonDecode(response!.body);
    card = temp.map((e) => Cards.fromJson(e));
  }

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 5,
        ),
        Text(timerText)
      ],
    );
  }

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        getCard();
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (BuildContext context) => buildAlertDialog(
                    context,
                    "Karte anlegen ...",
                    "Es ist ein Fehler beim anlegen der Karte aufgetreten!",
                    [
                      generateButtonRectangle(
                        context,
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        }
        if (card.reader != "") {
          timer.cancel();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (BuildContext context) => buildAlertDialog(
                    context,
                    "Karte anlegen ...",
                    "Karte wurde angelegt!",
                    [
                      generateButtonRectangle(
                        context,
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        }
      });
    });
  }
}
