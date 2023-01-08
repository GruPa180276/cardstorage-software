import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/TimerActions.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/readercard.dart';
import 'package:web_socket_channel/io.dart';

import 'circular_timer/circular_countdown_timer.dart';

class MqttTimer {
  bool _successful = false;

  BuildContext context;
  TimerAction action;
  ReaderCard? card;
  String? email;
  String? storagename;
  Map? _responseData;
  var timerController = CountDownController();
  bool messageReceived = false;
  int timerDuration = 20;
  late CircularCountDownTimer timer;

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
        //useRootNavigator: false,
        context: context,
        builder: (BuildContext buildContext) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: CircularCountDownTimer(
                      duration: timerDuration,
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
                        var snackBar;
                        if (_successful) {
                          snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Karte wird heruntergelassen!',
                                message: '',

                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                contentType: ContentType.success,
                              ));
                        } else {
                          snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Etwas ist schiefgelaufen!',
                                message: _responseData.toString(),

                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                contentType: ContentType.failure,
                              ));
                        }
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        try {
                          Navigator.of(context).maybePop();
                        } catch (e) {}
                      }),
                      onStart: () async {
                        //maybe you need threading
                        if (action == TimerAction.GETCARD) {
                          var response =
                              await Data.postGetCardNow(card!, email!);
                          if (response.statusCode != 200) {
                            cancel();
                          }
                        } else if (action == TimerAction.SIGNUP) {
                          var response = await Data.postCreateNewUser(
                              email!, storagename!);

                          if (response.statusCode != 200) {
                            sleep(Duration(seconds: 1));
                            cancel();
                          }
                        }
                      },
                      timeFormatterFunction:
                          (defaultFormatterFunction, duration) {
                        return Function.apply(
                            defaultFormatterFunction, [duration]);
                      },
                    )),
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

  Map getResponse() {
    return _responseData ?? {"Error": "No Message received"};
  }

  void cancel() {
    Navigator.pop(context);
  }

  streamListener(IOWebSocketChannel channel) {
    channel.stream.listen((message) async {
      channel.sink.close();
      _responseData = jsonDecode(message);
      _successful = _responseData!["successful"] ??
          _responseData!["status"]["successful"];

      await channel.sink.close();
      timerController.restart(duration: 0);
    });
  }
}
