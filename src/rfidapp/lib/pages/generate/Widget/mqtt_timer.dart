import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:rfidapp/domain/enums/TimerActions.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/readercards.dart';
import 'package:web_socket_channel/io.dart';

class MqttTimer {
  bool _successful = false;

  BuildContext context;
  TimerAction action;
  ReaderCard? card;
  String? email;
  String? storagename;

  MqttTimer(
      {Key? key,
      required this.context,
      required this.action,
      this.card,
      this.email,
      this.storagename});

  Future<void> startTimer() {
    final channel = IOWebSocketChannel.connect(
      'wss://10.0.2.2:7171/api/controller/log',
    );
    streamListener(channel);

    int timestamp = 0;
    _successful = false;

    //send Data to rfid chip, that it should start scanning
    //15seconds time
    //thread that checks if toke is here
    return showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircularCountDownTimer(
                    duration: 20,
                    initialDuration: 0,
                    controller: CountDownController(),
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
                    onComplete: (() => Navigator.pop(context)),
                    onStart: () async {
                      //maybe you need threading
                      if (action == TimerAction.GETCARD) {
                        //post to Api
                      } else if (action == TimerAction.SIGNUP) {
                        var response =
                            await Data.postCreateNewUser(email!, storagename!);

                        if (response.statusCode != 200) {
                          cancel();
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

  void cancel() {
    Navigator.pop(context);
  }

  streamListener(IOWebSocketChannel channel) {
    channel.stream.listen((message) {
      channel.sink.close();
      Map getData = jsonDecode(message);
      print(getData["successful"]);
      _successful = getData["successful"];
      cancel();
      channel.sink.close();
    });
  }
}
