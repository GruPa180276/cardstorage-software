import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/widget/cards/email_button.dart';
import 'package:rfidapp/pages/generate/widget/cards/favorite_button.dart';
import 'package:rfidapp/pages/generate/widget/cards/card_bottom_row.dart';
import 'package:rfidapp/provider/rest/types/readercard.dart';

class FavoriteView extends StatelessWidget {
  final List<ReaderCard> cards;
  final BuildContext context;
  final Set<String> pinnedCards;
  final Function reloadPinned;
  final String searchstring;
  final void Function() reloadCard;
  final void Function(void Function()) setState;

  const FavoriteView({
    super.key,
    required this.cards,
    required this.context,
    required this.pinnedCards,
    required this.reloadPinned,
    required this.searchstring,
    required this.reloadCard,
    required this.setState,
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
                      'Sie haben keine Favoriten',
                      style: TextStyle(
                          color: Theme.of(context).cardColor, fontSize: 20),
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
                        ReaderCardButtons(
                          key: key,
                          card: cards[index],
                          reloadCard: reloadPinned,
                          setState: setState,
                        )
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
