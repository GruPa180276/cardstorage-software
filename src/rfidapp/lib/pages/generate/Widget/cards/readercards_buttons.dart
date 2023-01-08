import 'package:flutter/cupertino.dart';
import 'package:rfidapp/domain/enums/TimerActions.dart';
import 'package:rfidapp/pages/generate/Widget/mqtt_timer.dart';
import 'package:rfidapp/pages/generate/widget/createCardButton.dart';
import 'package:rfidapp/provider/types/readercards.dart';

class ReaderCardButtons extends StatelessWidget {
  final ReaderCard card;

  const ReaderCardButtons({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!card.available)
        ? SizedBox.shrink()
        : Row(
            children: [
              Expanded(
                //get card
                child: CardButton(
                    text: 'Jetzt holen',
                    onPress: () {
                      MqttTimer(context: context, action: TimerAction.GETCARD)
                          .startTimer();
                    }),
              )
            ],
          );
  }
}
