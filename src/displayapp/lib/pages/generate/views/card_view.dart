import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/widget/mqtt_timer.dart';
import 'package:rfidapp/pages/generate/widget/createCardButton.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';

Widget cardsView(Storage storage, BuildContext context, String site,


        String searchstring) =>
    Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: storage.cards!.length,
          itemBuilder: (context, index) {
            bool card = false;

            card = storage.cards![index].name.contains(searchstring);

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
                        buildCardsText(context, storage.cards![index], site),
                      ]),
                      buildBottomButton(context, site, storage.cards![index])
                    ]))
                : Container();
          }),
    );

Widget buildCardsText(BuildContext context, ReaderCards card, String site) {
  Color colorAvailable = Colors.green;

  if (!card.available) {
    colorAvailable = Colors.red;
  }

  return Padding(
    padding: const EdgeInsets.all(20.0),
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
            const TableCell(child: Text("Verfuegbar:")),
            TableCell(
              child: Text(
                card.available.toString(),
                style: TextStyle(
                    color: colorAvailable, fontWeight: FontWeight.bold),
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
        )
      ],
    ),
  );
}

Widget buildBottomButton(BuildContext context, String site, ReaderCards card) {
  switch (site) {
    case 'cards':

      return Row(
        children: [
          Expanded(
            //get card
            child: CardButton(
                text: 'Jetzt holen',
                onPress: () {
                  MqttTimer.startTimer(context, "to-get-card");
                }),
          )
        ],
      );
  }
  return const SizedBox();
}
