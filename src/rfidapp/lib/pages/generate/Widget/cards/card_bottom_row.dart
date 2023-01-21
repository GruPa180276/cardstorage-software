import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/enums/timer_actions.dart';
import 'package:rfidapp/pages/generate/pop_up/request_timer.dart';
import 'package:rfidapp/pages/generate/pop_up/reservate_popup.dart';
import 'package:rfidapp/pages/generate/widget/cards/card_button.dart';
import 'package:rfidapp/provider/types/readercard.dart';

class ReaderCardButtons extends StatelessWidget {
  final ReaderCard card;
  final Function reloadCard;
  void Function(void Function() p1)? setState;
  ReaderCardButtons(
      {super.key, required this.card, required this.reloadCard, this.setState});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!card.available)
        ? Row(
            children: [
              Expanded(
                child: CardButton(
                    text: 'Reservieren',
                    onPress: () async {
                      await ReservationPopUp(context, card).build();
                    }),
              ),
            ],
          )
        : Container(
            height: 50,
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
                VerticalDivider(
                  color: Theme.of(context).dividerColor,
                  thickness: 1,
                  width: 1,
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
                              email: await UserSecureStorage.getUserEmail());
                          await reqTimer.startTimer();
                          if (reqTimer.getSuccessful()) {
                            setState!(
                              () {
                                this.card.available = false;
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
