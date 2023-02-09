import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:rfidapp/domain/enum/snackbar_type.dart';
import 'package:rfidapp/pages/widgets/pop_up/response_snackbar.dart';
import 'package:rfidapp/provider/storage_properties.dart';
import 'package:web_socket_channel/io.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/rest/types/cards.dart';

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
        Uri.parse(
            'wss://${StorageProperties.getServer()}:${StorageProperties.getRestPort()}/api/v1/controller/log'),
        headers: <String, String>{
          HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
          'Accept': 'application/json'
        });
    _streamListener();
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
                        SnackbarBuilder(
                                context: context,
                                snackbarType: SnackbarType.failure,
                                header: "Verbindungsfehler!",
                                content: _responseData)
                            .build();
                        Navigator.maybePop(context);
                      } else if (i == 0) {
                        SnackbarBuilder(
                                context: context,
                                snackbarType: SnackbarType.failure,
                                header: "Verbindungsfehler!",
                                content: _responseData)
                            .build();
                        Navigator.maybePop(context);
                      }
                      i++;
                    }),
                    onStart: () async {
                      this.context = context;
                      if (card != null) {
                        var response = await Data.check(
                            Data.postGetCardNow, {"cardname": card!.name});
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

  _streamListener() {
    channel?.stream.listen((message) {
      _responseData = jsonDecode(message);
      _successful = _responseData!["successful"] ??
          _responseData!["status"]["successful"];
      channel!.sink.close();
      i++;
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
      } else if (card == null && i == 1) {
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
      Navigator.maybePop(context);
    });
  }
}
