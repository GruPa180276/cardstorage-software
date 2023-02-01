import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:rfidapp/domain/enum/snackbar_type.dart';
import 'package:rfidapp/pages/generate/widget/response_snackbar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/types/cards.dart';

class RequestTimer {
  Map? _responseData;
  var timerController = CountDownController();
  late bool _successful = false;
  int i = 0;
  BuildContext context;
  ReaderCard? card;
  IOWebSocketChannel? channel;
  RequestTimer({required this.context, this.card});

  Future<void> build() {
    i = 0;
    channel = IOWebSocketChannel.connect(
        Uri.parse('wss://10.0.2.2:7171/api/controller/log'));
    streamListener();
    int timestamp = 0;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircularCountDownTimer(
                    duration: 20,
                    initialDuration: 0,
                    controller: timerController,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    ringColor: Colors.green[300]!,
                    ringGradient: null,
                    fillColor: Colors.green[100]!,
                    fillGradient: null,
                    backgroundColor: Colors.green[500],
                    backgroundGradient: null,
                    strokeWidth: 20.0,
                    strokeCap: StrokeCap.round,
                    textStyle: const TextStyle(
                        fontSize: 33.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textFormat: CountdownTextFormat.S,
                    isReverse: false,
                    isReverseAnimation: false,
                    isTimerTextShown: true,
                    autoStart: true,
                    onComplete: (() {
                      channel!.sink.close();

                      if (card != null && i == 0) {
                        SnackbarBuilder.build(SnackbarType.Karten, context,
                            _successful, _responseData);
                        Navigator.maybePop(context);
                      } else if (i == 0) {
                        SnackbarBuilder.build(SnackbarType.User, context,
                            _successful, _responseData);
                        Navigator.maybePop(context);
                      }
                      i++;
                    }),
                    onStart: () async {
                      this.context = context;
                      if (card != null) {
                        var response = await Data.postGetCardNow(card!);
                        if (response.statusCode != 200) {
                          Navigator.maybePop(context);
                        }
                      }
                    },
                    timeFormatterFunction:
                        (defaultFormatterFunction, duration) {
                      return Function.apply(
                          defaultFormatterFunction, [duration]);
                    },
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 350, 0, 0),
                    child: Text(
                      "Halten Sie Ihre Karte an den Sensor!",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  bool getSuccessful() {
    return _successful;
  }

  streamListener() {
    channel?.stream.listen((message) {
      _responseData = jsonDecode(message);
      _successful = _responseData!["successful"] ??
          _responseData!["status"]["successful"];
      channel!.sink.close();
      i++;
      timerController.restart(duration: 0);

      if (card != null) {
        SnackbarBuilder.build(
            SnackbarType.Karten, context, _successful, _responseData);
      } else {
        SnackbarBuilder.build(
            SnackbarType.User, context, _successful, _responseData);
      }
      print("This print is required");
      Navigator.maybePop(context);
    });
  }
}

enum _TimerType { InitTimer, Breaktimer }
