import 'package:flutter/material.dart';
import 'package:rfidapp/domain/app_preferences.dart';
import 'package:rfidapp/domain/enums/TimerActions.dart';
import 'package:rfidapp/pages/generate/pop_up/email_popup.dart';
import 'package:rfidapp/pages/generate/widget/mqtt_timer.dart';
import 'package:rfidapp/pages/generate/widget/createCardButton.dart';
import 'package:rfidapp/provider/types/readercards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class CardView extends StatelessWidget {
  List<ReaderCard> readercards;
  BuildContext context;
  String searchstring;
  Set<String> pinnedCards;
  void Function() reloadPinned;
  CardView(
      {Key? key,
      required this.readercards,
      required this.context,
      required this.searchstring,
      required this.pinnedCards,
      required this.reloadPinned});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: readercards.length,
          itemBuilder: (context, index) {
            bool card = false;
            card = readercards[index].name.contains(searchstring);

            return card
                ? Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(children: [
                      Row(children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 30, 0),
                          child: Icon(Icons.credit_card_outlined, size: 35),
                        ),
                        _buildCardsText(context, readercards[index]),
                      ]),
                      _buildCardsButton(context, readercards[index])
                    ]))
                : Container();
          }),
    );
  }

  Widget _buildCardsText(BuildContext context, ReaderCard card) {
    Widget emailButton = (!card.available)
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

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Table(
            //border: TableBorder.all(),

            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(150),
              1: FixedColumnWidth(100),
            },

            children: [
              TableRow(
                children: [
                  const TableCell(child: Text("Name:")),
                  TableCell(child: Text(card.name))
                ],
              ),
              TableRow(
                children: [
                  const TableCell(child: Text("Storage:")),
                  TableCell(child: Text(card.storageName!))
                ],
              ),
              TableRow(
                children: [
                  const TableCell(child: Text("Verfuegbar:")),
                  TableCell(
                    child: Text(
                      card.available.toString(),
                      style: TextStyle(
                          color: (!card.available) ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              TableRow(
                children: [
                  const TableCell(child: Text("Position:")),
                  TableCell(
                    child: Text(
                      card.position.toString(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        favoriteButton(card),
        emailButton
      ],
    );
  }

  static Widget _buildCardsButton(BuildContext context, ReaderCard card) {
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

  Widget favoriteButton(ReaderCard card) {
    var colorPin = (pinnedCards.contains(card.name.toString())
        ? Colors.yellow
        : Theme.of(context).primaryColor);

    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return IconButton(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width - 160, 0, 0, 0),
        onPressed: () {
          setState(
            () {
              if (!(pinnedCards.contains(card.name.toString()))) {
                colorPin = Colors.yellow;
                AppPreferences.addCardPinned(card.name.toString());
              } else {
                AppPreferences.removePinnedCardAt(card.name);
                pinnedCards = AppPreferences.getCardsPinned();
                colorPin = Theme.of(context).primaryColor;
              }
              reloadPinned();
            },
          );
        },
        icon: Icon(Icons.star, color: colorPin),
        splashColor: Colors.transparent,
        splashRadius: 0.1,
      );
    });
  }
}
