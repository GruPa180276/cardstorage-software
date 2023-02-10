// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:card_master/client/pages/widgets/inherited/cards_inherited.dart';
import 'package:card_master/client/pages/widgets/widget/cards/email_button.dart';
import 'package:card_master/client/pages/widgets/widget/cards/favorite_button.dart';
import 'package:card_master/client/pages/widgets/widget/cards/card_bottom_row.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';

class CardView extends StatelessWidget {
  late CardViewData data;

  CardView({super.key});
  @override
  Widget build(BuildContext context) {
    data = CardViewData.of(context)!;
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: data.readercards.length,
          itemBuilder: (context, index) {
            bool card = false;
            card = data.readercards[index].name.contains(data.searchstring);

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
                        _buildCardsText(context, data.readercards[index]),
                      ]),
                      ReaderCardButtons(
                          card: data.readercards[index],
                          reloadCard: data.reloadCard,
                          setState: data.setState)
                    ]))
                : Container();
          }),
    );
  }

  Widget _buildCardsText(BuildContext context, ReaderCard card) {
    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Table(
              //border: TableBorder.all(),

              columnWidths: const <int, TableColumnWidth>{
                0: FractionColumnWidth(0.59),
                1: FractionColumnWidth(0.4),
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
                            color:
                                (!card.available) ? Colors.red : Colors.green,
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
              card: card,
              reloadPinned: data.reloadPinned,
              pinnedCards: data.pinnedCards),
          EmailButton(card: card)
        ],
      ),
    );
  }
}
