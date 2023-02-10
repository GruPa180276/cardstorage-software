import 'package:card_master/client/pages/widgets/card/favorite_button.dart';
import 'package:card_master/client/pages/widgets/inherited/cards_text_inherited.dart';
import 'package:card_master/client/pages/widgets/widget/buttons/email_button.dart';

import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  TextView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = CardTextData.of(context)!;
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
                    TableCell(child: Text(data.card.name))
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("Storage:")),
                    TableCell(child: Text(data.card.storageName!))
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("Verfuegbar:")),
                    TableCell(
                      child: Text(
                        data.card.available.toString(),
                        style: TextStyle(
                            color: (!data.card.available)
                                ? Colors.red
                                : Colors.green,
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
                        data.card.position.toString(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          FavoriteButton(
              card: data.card,
              reloadPinned: data.reloadPinned,
              pinnedCards: data.pinnedCards),
          EmailButton(card: data.card)
        ],
      ),
    );
  }
}
