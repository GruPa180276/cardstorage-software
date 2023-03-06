// ignore_for_file: must_be_immutable

import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/inherited/card_inherited.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/types/timer_action_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/request_timer.dart';
import 'package:card_master/client/pages/widgets/pop_up/reservate_popup.dart';
import 'package:card_master/client/pages/widgets/card/card_button.dart';

class ReaderCardButtons extends StatelessWidget {
  late CardData cardData;

  ReaderCardButtons({super.key});
  @override
  Widget build(BuildContext context) {
    cardData = CardData.of(context)!;
    return (!cardData.card.available)
        ? SizedBox(
            height: 7.0.hs,
            child: Row(
              children: [
                Expanded(
                  child: CardButton(
                      text: 'Reservieren',
                      onPress: () async {
                        await ReservationPopUp(context, cardData.card).build();
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
                        await ReservationPopUp(context, cardData.card).build();
                      }),
                ),
                Expanded(
                  //get card
                  child: CardButton(
                      borderLeftSide: true,
                      text: 'Jetzt holen',
                      onPress: () async {
                        try {
                          var reqTimer = RequestTimer(
                            context: context,
                            action: TimerAction.GETCARD,
                            card: cardData.card,
                          );
                          await reqTimer.startTimer();
                          if (reqTimer.getSuccessful()) {
                            // ignore: use_build_context_synchronously
                            FeedbackBuilder(
                                    context: context,
                                    snackbarType: FeedbackType.success,
                                    header: "Karten wird heruntergelassen!",
                                    content: null)
                                .build();
                            cardData.setState!(() {
                              cardData.card.available = false;
                            });
                          } else {
                            // ignore: use_build_context_synchronously
                            FeedbackBuilder(
                                    context: context,
                                    snackbarType: reqTimer.getFeedbackType()!,
                                    header: "Karte abholen gescheitert",
                                    content: reqTimer.getResponse())
                                .build();
                          }
                          // ignore: empty_catches
                        } catch (e) {}
                      }),
                )
              ],
            ),
          );
  }
}
