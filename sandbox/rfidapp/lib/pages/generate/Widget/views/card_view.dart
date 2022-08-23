// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/pop_up/reservate_popup.dart';

Widget cardsView(List<Cards> cards, BuildContext context) => ListView.builder(
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
                child: Icon(Icons.card_giftcard_sharp, size: 35),
              ),
              buildCardsText(context, card),
            ]),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    shape: Border(
                        top: BorderSide(color: ColorSelect.greyBorderColor),
                        right: BorderSide(color: ColorSelect.greyBorderColor)),
                    color: Colors.transparent,
                    splashColor: Colors.black,
                    onPressed: () => buildReservatePopUp(context),
                    child: Text('Reservieren',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    shape: Border(
                        top: BorderSide(color: ColorSelect.greyBorderColor),
                        right: BorderSide(color: ColorSelect.greyBorderColor)),
                    color: Colors.transparent,
                    splashColor: Colors.black,
                    onPressed: () => buildReservatePopUp(context),
                    child: Text('Jetzt holen',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ],
            )
          ]));
    });

Widget buildCardsText(context, Cards card) {
  Color colorAvailable = Colors.green;
  if (card.isAvailable) Color colorAvailable = Colors.red;

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
            TableCell(child: Text("ID:")),
            TableCell(child: Text(card.id.toString()))
          ],
        ),
        TableRow(
          children: [
            TableCell(child: Text("Name:")),
            TableCell(child: Text(card.name.toString()))
          ],
        ),
        TableRow(
          children: [
            TableCell(child: Text("StorageId:")),
            TableCell(child: Text(card.storageId.toString()))
          ],
        ),
        TableRow(
          children: [
            TableCell(child: Text("Verfuegbar:")),
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

      // child: Column(

      //   crossAxisAlignment: CrossAxisAlignment.start,

      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      //   children: [

      //     Row(children: [Text("ID:"), Text(card.id.toString())]),

      //     Row(children: [Text("Name:"), Text(card.name)]),

      //     Row(

      //       children: [Text("StorageId:"), Text(card.storageId.toString())],

      //     ),

      //     Row(

      //       children: [Text("Verfuegbar"), Text(card.isAvailable.toString())],

      //     )

      //   ],

      // ),
    ),
  );
}
