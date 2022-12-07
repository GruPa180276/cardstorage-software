import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:rfidapp/provider/restApi/data.dart';

class MqttTimer {
  static late BuildContext context;
  static bool _successful = false;
  static Future<void> startTimer(BuildContext context, String action) {
    MqttTimer.context = context;
    int timestamp = 0;
    _successful=false;
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
                    onStart: () {
                      //maybe you need threading
                      if (action == "to-get-card") {
                        //post to Api
                      } else if (action == "to-sign-up") {
                        //post to api
                      }
                    },
                    timeFormatterFunction:
                        (defaultFormatterFunction, duration) {
                      if (duration.inSeconds % 3 == 0 &&
                          duration.inSeconds != timestamp) {
                        timestamp = duration.inSeconds;
                        if (action == "to-get-card") {
                          //for one card
                          Data.getCardsData();
                          //cancel if successful
                          cancel();
                        } else if (action == "to-sign-up") {
                          //see if User is in DB now
                          //Data.isUserRegistered?();
                          bool isRegistered=true;
                          if(isRegistered=true){
                            _successful=true;
                            cancel();
                          }
                          
                        }
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

  static bool getSuccessful() {
    return _successful;
  }

  static void cancel() {
    Navigator.pop(context);
  }
}
