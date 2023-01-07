import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/pop_up/email_popup.dart';
import 'package:rfidapp/pages/generate/widget/createCardButton.dart';
import 'package:rfidapp/pages/generate/widget/mqtt_timer.dart';
import 'package:rfidapp/provider/types/readercards.dart';
import 'package:rfidapp/pages/generate/pop_up/reservate_popup.dart';
import 'package:rfidapp/domain/app_preferences.dart';

class FavoriteView extends StatelessWidget {
  List<ReaderCard> cards;
  BuildContext context;
  Set<String> pinnedCards;
  Function reloadPinned;
  String searchstring;

  FavoriteView({
    Key? key,
    required this.cards,
    required this.context,
    required this.pinnedCards,
    required this.reloadPinned,
    required this.searchstring,
  });

  @override
  Widget build(BuildContext context) => Flexible(
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              bool card = false;

              if (pinnedCards.isEmpty && index == cards.length - 1) {
                return Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 2 - 200,
                        horizontal: 0),
                    child: Text(
                      'Sie haben keine Favoriten ;)',
                      style: TextStyle(
                          color: Theme.of(context).dividerColor, fontSize: 20),
                    ),
                  ),
                );
              }
              for (String id in pinnedCards) {
                card = cards[index].name.toString().contains(id);
                if (card) {
                  break;
                }
              }

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
                          buildCardsText(
                              context, cards[index], pinnedCards, reloadPinned),
                        ]),
                        buildBottomButton(context, cards[index])
                      ]))
                  : Container();
            }),
      );

  Widget buildCardsText(BuildContext context, ReaderCard card,
      Set<String> pinnedCards, Function reloadPinned) {
    bool isFavorised = false;

    Color colorPin = Theme.of(context).primaryColor;
    Color colorAvailable = Colors.green;
    if (pinnedCards.contains(card.name.toString())) {
      colorPin = Colors.yellow;
      isFavorised = true;
    }

    Widget favoriteButton = IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.podcasts,
          color: Theme.of(context).cardColor,
        ));

    Widget emailButton = IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.podcasts,
          color: Theme.of(context).cardColor,
        ));

    if (!card.available) {
      colorAvailable = Colors.red;
    }

    if (!card.available) {
      emailButton = Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width - 171, 55, 0, 0),
          child: IconButton(
              onPressed: () async {
                EmailPopUp.show(
                    //send to mail
                    context,
                    "grubauer.patrick@gmail.com",
                    "Test",
                    "Test");
              },
              icon: Icon(Icons.email)));
    }

    favoriteButton = StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return IconButton(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width - 160, 0, 0, 0),
          onPressed: () {
            setState(
              () {
                isFavorised = !isFavorised;
                if (isFavorised) {
                  colorPin = Colors.yellow;
                  AppPreferences.addCardPinned(card.name.toString());
                } else {
                  colorPin = Theme.of(context).primaryColor;
                  AppPreferences.removePinnedCardAt(card.name);
                  pinnedCards = AppPreferences.getCardsPinned();
                  reloadPinned();
                }
              },
            );
          },
          splashColor: Colors.transparent,
          splashRadius: 0.1,
          icon: Icon(
            Icons.star,
            color: colorPin,
          ));
    });

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
                  TableCell(child: Text(card.name.toString()))
                ],
              ),
              TableRow(
                children: [
                  const TableCell(child: Text("Storage:")),
                  TableCell(child: Text(card.storageName.toString()))
                ],
              ),
              TableRow(
                children: [
                  const TableCell(child: Text("Verfuegbar:")),
                  TableCell(
                    child: Text(
                      card.available.toString(),
                      style: TextStyle(
                          color: colorAvailable, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        favoriteButton,
        emailButton
      ],
    );
  }

  Widget buildBottomButton(BuildContext context, ReaderCard card) {
    Widget getNow = const SizedBox(
      width: 0,
      height: 0,
    );
    if (card.available) {
      return Row(
        children: [
          Expanded(
              child: CardButton(
                  text: 'Jetzt holen',
                  onPress: () => MqttTimer(
                          context: context, action: "to-get-card", card: card)
                      .startTimer())),
          SizedBox(
            width: 1,
            height: 50,
            child: Container(
              color: Theme.of(context).dividerColor,
            ),
          ),
          Expanded(
              child: CardButton(
                  text: 'Reservieren',
                  onPress: () => buildReservatePopUp(context, card)))
        ],
      );
    }
    return Stack(
      children: [
        Row(
          children: <Widget>[
            getNow,
            Expanded(
                child: CardButton(
                    text: 'Reservieren',
                    onPress: () => buildReservatePopUp(context, card))),
          ],
        ),
      ],
    );
  }
}
