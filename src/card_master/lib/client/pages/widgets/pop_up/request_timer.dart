// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:card_master/client/config/properties/server_properties.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/domain/types/timer_action_type.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';
import 'package:web_socket_channel/io.dart';

import '../widget/circular_timer/circular_countdown_timer.dart';

class RequestTimer {
  String? _responseData;
  var timerController = CountDownController();
  late bool _successful = false;
  IOWebSocketChannel? _websocket;
  final BuildContext context;
  final TimerAction action;
  final ReaderCard? card;
  final String? email;
  final String? storagename;
  late FeedbackType _feedbackType;

  bool getSuccessful() {
    return _successful;
  }

  String? getResponse() {
    return _responseData;
  }

  FeedbackType? getFeedbackType() {
    return _feedbackType;
  }

  RequestTimer(
      {required this.context,
      required this.action,
      this.card,
      this.email,
      this.storagename});

  Future<void> startTimer() async {
    _successful = false;
    _websocket = IOWebSocketChannel.connect(
        Uri.parse(
            'wss://${ServerProperties.getServer()}:${ServerProperties.getRestPort()}${ServerProperties.getBaseUri()}controller/log'),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${Data.bearerToken}",
        });
    _websocketListener();
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
                        _feedbackType = FeedbackType.warning;
                        _responseData = "Zeit ist abgelaufen!";
                        Navigator.of(context).maybePop();
                        _websocket!.sink.close();
                      }),
                      onStart: () async {
                        //maybe you need threading
                        if (action == TimerAction.GETCARD) {
                          var response = await Data.checkAuthorization(
                              context: context,
                              function: Data.postGetCardNow,
                              args: {"cardname": card!.name});
                          if (response!.statusCode != 200) {
                            _feedbackType = FeedbackType.failure;
                            _responseData = response.body;

                            Navigator.maybePop(context);
                          }
                        } else if (action == TimerAction.SIGNUP) {
                          var response = await Data.checkAuthorization(
                              context: context,
                              function: Data.postCreateNewUser,
                              args: {
                                "storagename": storagename!,
                                "email": email!
                              });
                          if (response!.statusCode != 200) {
                            _feedbackType = FeedbackType.failure;
                            _responseData = response.body;
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

  _websocketListener() {
    _websocket!.stream.listen((message) async {
      var response = jsonDecode(message);
      _successful =
          response!["successful"] ?? response!["status"]["successful"];
      _responseData = response.toString();
      _feedbackType =
          (_successful) ? FeedbackType.success : FeedbackType.failure;
      _websocket!.sink.close();
      Navigator.of(context).maybePop();
    });
  }
}
