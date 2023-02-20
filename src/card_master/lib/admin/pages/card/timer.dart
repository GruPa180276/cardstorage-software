import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/navigation/websockets.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';

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
    Map? responseData;
    bool successful = false;

    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        responseData = jsonDecode(Websockets.messages.last);
        successful = responseData!["successful"];

        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          FeedbackBuilder(
            context: context,
            header: "Error!",
            snackbarType: FeedbackType.failure,
            content: "Karte konnte nicht hinzugefügt werden.",
          ).build();
        }

        if (successful) {
          timer.cancel();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          FeedbackBuilder(
            context: context,
            header: "Karte hinzugefügt!",
            snackbarType: FeedbackType.success,
            content: "Karte wurde erfolgreich angelegt.",
          ).build();
        }
      });
    });
  }
}
