import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/enums/timer_actions.dart';
import 'package:rfidapp/pages/generate/widget/request_timer.dart';
import 'package:rfidapp/pages/generate/widget/cards/button.dart';
import 'package:rfidapp/provider/types/readercard.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
        ? SizedBox.shrink()
        : Row(
            children: [
              Expanded(
                //get card
                child: CardButton(
                    text: 'Jetzt holen',
                    onPress: () async {
                      try {
                        await RequestTimer.startTimer(
                            context,
                            TimerAction.GETCARD,
                            card,
                            await UserSecureStorage.getUserEmail(),
                            null);
                        if (RequestTimer.getSuccessful()) {
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
          );
  }
}
