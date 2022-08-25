// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/Widget/reservate_button.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/pages/generate/widget/pop_up/reservate_popup.dart';

Widget cardsView(List<Cards> cards, BuildContext context, String site) =>
    ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];

          return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(children: [
                Row(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 30, 0),
                    child: Icon(Icons.credit_card_outlined, size: 35),
                  ),
                  buildCardsText(context, card),
                ]),
                buildBottomButton(context, site, card)
              ]));
        });

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
                  top: BorderSide(color: ColorSelect.greyBorderColor),
                  right: BorderSide(color: ColorSelect.greyBorderColor)),
              color: Colors.transparent,
              splashColor: Colors.black,
              onPressed: () {
                card.isReserved = false;
                Data.putData("cards", card.toJson());
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
            children: [buildReservateButton(context, "Bearbeiten")],
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
                top: BorderSide(color: ColorSelect.greyBorderColor),
                right: BorderSide(color: ColorSelect.greyBorderColor)),
            color: Colors.transparent,
            splashColor: Colors.black,
            onPressed: () => buildReservatePopUp(context),
            child: Text('Jetzt holen',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        );
      }
      return Row(
        children: <Widget>[
          getNow,
          buildReservateButton(context, "Reservieren")
        ],
      );
  }
  return const Text('error');
}
