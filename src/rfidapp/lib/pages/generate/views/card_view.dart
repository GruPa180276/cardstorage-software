// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/widget/reservate_button.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/pages/generate/pop_up/reservate_popup.dart';

Widget cardsView(List<Cards> cards, BuildContext context, String site,
        String searchstring) =>
    Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index].name?.contains(searchstring);

            return cards[index].name!.contains(searchstring)
                ? Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(children: [
                      Row(children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 30, 0),
                          child: Icon(Icons.credit_card_outlined, size: 35),
                        ),
                        buildCardsText(context, cards[index]),
                      ]),
                      buildBottomButton(context, site, cards[index])
                    ]))
                : Container();
          }),
    );

Widget buildCardsText(BuildContext context, Cards card) {
  Color colorAvailable = Colors.green;
  if (!card.isAvailable!) colorAvailable = Colors.red;

  return Padding(
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
            const TableCell(child: Text("ID:")),
            TableCell(child: Text(card.id.toString()))
          ],
        ),
        TableRow(
          children: [
            const TableCell(child: Text("Name:")),
            TableCell(child: Text(card.name.toString()))
          ],
        ),
        TableRow(
          children: [
            const TableCell(child: Text("StorageId:")),
            TableCell(child: Text(card.storageId.toString()))
          ],
        ),
        TableRow(
          children: [
            const TableCell(child: Text("Verfuegbar:")),
            TableCell(
              child: Text(
                card.isAvailable.toString(),
                style: TextStyle(
                    color: colorAvailable, fontWeight: FontWeight.bold),
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget buildBottomButton(BuildContext context, String site, Cards card) {
  switch (site) {
    case 'reservation':
      return Row(
        children: [
          Expanded(
            child: FlatButton(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              shape: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                  right: BorderSide(color: Theme.of(context).dividerColor)),
              color: Colors.transparent,
              splashColor: Colors.black,
              onPressed: () {
                card.isReserved = false;
                Data.putData("card", card.toJson());
                //TODO maybe change to SetState (cleaner)
                // ignore: invalid_use_of_protected_member
                (context as Element).reassemble();
              },
              child: Text('Loeschen',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Expanded(
              child: Row(
            children: [buildReservateButton(context, "Bearbeiten", card)],
          ))
        ],
      );
    case 'cards':
      Widget getNow = const SizedBox(
        width: 0,
        height: 0,
      );
      if (card.isAvailable!) {
        getNow = Expanded(
          child: FlatButton(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            shape: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
                right: BorderSide(color: Theme.of(context).dividerColor)),
            color: Colors.transparent,
            splashColor: Colors.black,
            onPressed: () => buildReservatePopUp(context, card),
            child: Text('Jetzt holen',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        );
      }
      return Row(
        children: <Widget>[
          getNow,
          buildReservateButton(context, "Reservieren", card)
        ],
      );
  }
  return const Text('error');
}
