import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/widget/cards/email_button.dart';
import 'package:rfidapp/pages/generate/widget/cards/favorite_button.dart';
import 'package:rfidapp/pages/generate/widget/cards/readercards_buttons.dart';
import 'package:rfidapp/provider/types/readercard.dart';

class CardView extends StatelessWidget {
  List<ReaderCard> readercards;
  BuildContext context;
  String searchstring;
  Set<String> pinnedCards;
  void Function() reloadPinned;
  void Function() reloadCard;
  final void Function(void Function()) setState;

  CardView(
      {Key? key,
      required this.readercards,
      required this.context,
      required this.searchstring,
      required this.pinnedCards,
      required this.reloadPinned,
      required this.reloadCard,
      required this.setState});

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
                      ReaderCardButtons(
                          key: key,
                          card: readercards[index],
                          reloadCard: reloadCard,
                          setState: setState)
                    ]))
                : Container();
          }),
    );
  }

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
