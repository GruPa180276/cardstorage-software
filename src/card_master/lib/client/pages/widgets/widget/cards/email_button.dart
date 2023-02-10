import 'package:flutter/material.dart';
import 'package:card_master/client/pages/widgets/pop_up/email_popup.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';

class EmailButton extends StatelessWidget {
  final ReaderCard card;

  const EmailButton({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return (!card.available)
        ? Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width - 171, 55, 0, 0),
            child: IconButton(
                onPressed: () async {
                  EmailPopUp(
                          context: context,
                          to: card.reservation!
                              .firstWhere(
                                  (element) => element.isreservation == false)
                              .user
                              .email,
                          subject: card.name,
                          body: "${card.name} Frage.")
                      .show(
                          //send to mail
                          );
                },
                icon: const Icon(Icons.email)))
        : const SizedBox.shrink();
  }
}
