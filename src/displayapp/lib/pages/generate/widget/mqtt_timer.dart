import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:rfidapp/provider/restApi/data.dart';

class MqttTimer {
  static late BuildContext context;

  static Future<void> startTimer(BuildContext context, String action) {
    MqttTimer.context = context;
    //send Data to rfid chip, that it should start scanning
    //15seconds time
    //thread that checks if toke is here
    int timestamp = 0;
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
                    onStart: () {
                      //post to api
                      //containing card inf
                    },
                    timeFormatterFunction:
                        (defaultFormatterFunction, duration) {
                      if (duration.inSeconds % 3 == 0 &&
                          duration.inSeconds != timestamp) {
                        timestamp = duration.inSeconds;
                        //@TODO check card satsus if available during timeperiod
                        //get isavailable of specific card see if its false...then pop
                      }
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

  static void cancel() {
    Navigator.pop(context);
  }
}
