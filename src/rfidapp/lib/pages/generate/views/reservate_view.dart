import 'package:flutter/material.dart';

import 'package:rfidapp/provider/types/reservation.dart';

class ReservationView extends StatelessWidget {
  List<Reservation> cards;
  BuildContext context;

  String searchstring;

  ReservationView({
    Key? key,
    required this.cards,
    required this.context,
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
              card = cards[index].cardName!.contains(searchstring);
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
                        _buildBottomCards()
                      ]))
                  : Container();
            }),
      );

  Widget _buildCardsText(BuildContext context, Reservation card) {
    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
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
                    TableCell(child: Text(card.cardName!))
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
                    const TableCell(child: Text("Von:")),
                    TableCell(
                      child: Text(
                        card.since.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("Bis:")),
                    TableCell(
                      child: Text(
                        card.since.toString(),
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCards() {
    return Container();
  }
}
