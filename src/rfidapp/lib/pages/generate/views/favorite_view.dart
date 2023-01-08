import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/TimerActions.dart';
import 'package:rfidapp/pages/generate/pop_up/email_popup.dart';
import 'package:rfidapp/pages/generate/widget/cards/email_button.dart';
import 'package:rfidapp/pages/generate/widget/cards/favorite_button.dart';
import 'package:rfidapp/pages/generate/widget/cards/readercards_buttons.dart';
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
                card = (cards[index].name.toString() == id);
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
                          _buildCardsText(context, cards[index]),
                        ]),
                        ReaderCardButtons(card: cards[index])
                      ]))
                  : Container();
            }),
      );

  Widget _buildCardsText(BuildContext context, ReaderCard card) {
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
        FavoriteButton(
            card: card, reloadPinned: reloadPinned, pinnedCards: pinnedCards),
        EmailButton(card: card)
      ],
    );
  }
}
