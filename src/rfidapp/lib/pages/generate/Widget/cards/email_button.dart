import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/pop_up/email_popup.dart';
import 'package:rfidapp/provider/types/readercard.dart';

class EmailButton extends StatelessWidget {
  final ReaderCard card;

  const EmailButton({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return (!card.available)
        ? Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width - 171, 55, 0, 0),
            child: IconButton(
                onPressed: () async {
                  var asd = card.reservation!
                      .firstWhere((element) => element.isreservation == false)
                      .user;
                  EmailPopUp(
                          context: context,
                          to: card.reservation!
                              .firstWhere(
                                  (element) => element.isreservation == false)
                              .user
                              .email,
                          subject: card.name,
                          body: card.name + " Frage.")
                      .show(
                          //send to mail
                          );
                },
                icon: Icon(Icons.email)))
        : SizedBox.shrink();
  }
}
