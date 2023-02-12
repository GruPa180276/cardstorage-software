// ignore_for_file: must_be_immutable

import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/types/timer_action_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/request_timer.dart';
import 'package:card_master/client/pages/widgets/pop_up/reservate_popup.dart';
import 'package:card_master/client/pages/widgets/card/card_button.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';

class ReaderCardButtons extends StatelessWidget {
  final ReaderCard card;
  final Function reloadCard;
  void Function(void Function() p1)? setState;
  ReaderCardButtons(
      {super.key, required this.card, required this.reloadCard, this.setState});

  @override
  Widget build(BuildContext context) {
    return (!card.available)
        ? SizedBox(
            height: 7.0.hs,
            child: Row(
              children: [
                Expanded(
                  child: CardButton(
                      text: 'Reservieren',
                      onPress: () async {
                        await ReservationPopUp(context, card).build();
                      }),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 7.0.hs,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  //get card
                  child: CardButton(
                      text: 'Reservieren',
                      onPress: () async {
                        await ReservationPopUp(context, card).build();
                      }),
                ),
                Expanded(
                  //get card
                  child: CardButton(
                      text: 'Jetzt holen',
                      onPress: () async {
                        try {
                          var reqTimer = RequestTimer(
                            context: context,
                            action: TimerAction.GETCARD,
                            card: card,
                          );
                          await reqTimer.startTimer();
                          if (reqTimer.getSuccessful()) {
                            setState!(
                              () {
                                card.available = false;
                              },
                            );
                          }
                        } catch (e) {}
                      }),
                )
              ],
            ),
          );
  }
}
