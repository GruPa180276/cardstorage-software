// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/snackbar_type.dart';
import 'package:rfidapp/domain/enums/timer_actions_type.dart';
import 'package:rfidapp/pages/generate/widget/response_snackbar.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/rest/types/readercard.dart';
import 'package:web_socket_channel/io.dart';

import '../widget/circular_timer/circular_countdown_timer.dart';

class RequestTimer {
  Map? _responseData;
  var timerController = CountDownController();
  late bool _successful = false;
  int i = 0;
  IOWebSocketChannel? channel;
  final BuildContext context;
  final TimerAction action;
  final ReaderCard? card;
  final String? email;
  final String? storagename;
  bool getSuccessful() {
    return _successful;
  }

  Map getResponse() {
    return _responseData ?? {"Error": "No Message received"};
  }

  RequestTimer(
      {required this.context,
      required this.action,
      this.card,
      this.email,
      this.storagename});

  Future<void> startTimer() async {
    _successful = false;
    channel = IOWebSocketChannel.connect(
        Uri.parse('wss://10.0.2.2:7171/api/v1/controller/log'),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${Data.bearerToken}",
        });
    _streamListener();
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
                        if (card != null && i == 0) {
                          SnackbarBuilder(
                                  context: context,
                                  snackbarType: SnackbarType.failure,
                                  header: "Verbindungsfehler!",
                                  content: _responseData)
                              .build();
                          Navigator.of(context).maybePop();
                          channel!.sink.close();
                        } else if (storagename != null && i == 0) {
                          SnackbarBuilder(
                                  context: context,
                                  snackbarType: SnackbarType.failure,
                                  header: "Verbindungsfehler!",
                                  content: _responseData)
                              .build();
                          Navigator.of(context).maybePop();
                          channel!.sink.close();
                        }
                        i++;
                      }),
                      onStart: () async {
                        //maybe you need threading
                        if (action == TimerAction.GETCARD) {
                          var response = await Data.postGetCardNow(
                              {"cardname": card!.name, "email": email!});
                          if (response.statusCode != 200) {
                            Navigator.maybePop(context);
                          }
                        } else if (action == TimerAction.SIGNUP) {
                          var response = await Data.postCreateNewUser(
                              {"storagename": storagename!, "email": email!});
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

  _streamListener() {
    channel!.stream.listen((message) async {
      _responseData = jsonDecode(message);
      print(_responseData);
      _successful = _responseData!["successful"] ??
          _responseData!["status"]["successful"];
      i++;
      channel!.sink.close();
      if (card != null && i == 1) {
        if (_successful) {
          SnackbarBuilder(
                  context: context,
                  snackbarType: SnackbarType.success,
                  header: "Karte wird heruntergelassen!",
                  content: null)
              .build();
        } else {
          SnackbarBuilder(
                  context: context,
                  snackbarType: SnackbarType.failure,
                  header: "Verbindungsfehler!",
                  content: _responseData)
              .build();
        }
      } else if (storagename != null && i == 1) {
        if (_successful) {
          SnackbarBuilder(
                  context: context,
                  snackbarType: SnackbarType.failure,
                  header: "Registrierung erfolgreich!",
                  content: null)
              .build();
        } else {
          SnackbarBuilder(
                  context: context,
                  snackbarType: SnackbarType.failure,
                  header: "Verbindungsfehler!",
                  content: _responseData)
              .build();
        }
      }
      Navigator.of(context).maybePop();
    });
  }
}
