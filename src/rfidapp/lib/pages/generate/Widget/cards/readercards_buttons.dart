import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/enums/TimerActions.dart';
import 'package:rfidapp/pages/generate/widget/request_timer.dart';
import 'package:rfidapp/pages/generate/widget/cards/button.dart';
import 'package:rfidapp/provider/types/readercard.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ReaderCardButtons extends StatelessWidget {
  final ReaderCard card;
  final Function reloadCard;
  final GlobalKey<ScaffoldState> scaffoldKey;
  void Function(void Function() p1)? setState;
  ReaderCardButtons(
      {super.key,
      required this.card,
      required this.reloadCard,
      required this.scaffoldKey,
      this.setState});

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
                      var req = MqttTimer(
                          scaffoldKey: scaffoldKey,
                          context: context,
                          action: TimerAction.GETCARD,
                          card: card,
                          email: await UserSecureStorage.getUserEmail());
                      await req.startTimer();
                      if (req.getSuccessful()) {
                        setState!(
                          () {
                            this.card.available = false;
                          },
                        );

                        final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Karte wird heruntergelassen!',
                              message: '',

                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                              contentType: ContentType.success,
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Etwas ist schiefgelaufen!',
                              message: req.getResponse().toString(),

                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                              contentType: ContentType.failure,
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }),
              )
            ],
          );
  }
}
