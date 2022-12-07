import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/widget/mqtt_timer.dart';
import 'package:rfidapp/pages/generate/widget/createCardButton.dart';
import 'package:rfidapp/provider/types/cards.dart';

Widget cardsView(List<Cards> cards, BuildContext context, String site,
        Set<String> pinnedCards, Function reloadPinned, String searchstring) =>
    Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            bool card = false;

            if (site == 'favoriten') {
              if (pinnedCards.isEmpty && index == cards.length - 1) {
                return Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 2 - 200,
                        horizontal: 0),
                    child: Text(
                      'Sie haben keine Favoriten)',
                      style: TextStyle(
                          color: Theme.of(context).dividerColor, fontSize: 20),
                    ),
                  ),
                );
              }
              for (String id in pinnedCards) {
                card = cards[index].id.toString().contains(id);
                if (card) {
                  break;
                }
              }
            } else {
              card = cards[index].name!.contains(searchstring);
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
                        buildCardsText(context, cards[index], site, pinnedCards,
                            reloadPinned),
                      ]),
                      buildBottomButton(context, site, cards[index])
                    ]))
                : Container();
          }),
    );

Widget buildCardsText(BuildContext context, Cards card, String site,
    Set<String> pinnedCards, Function reloadPinned) {
  Color colorAvailable = Colors.green;

  // if (!card.isAvailable!) {
  //   colorAvailable = Colors.red;
  // }

  return Padding(
    padding: const EdgeInsets.all(10.0),
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
        // TableRow(
        //   children: [
        //     const TableCell(child: Text("StorageId:")),
        //     TableCell(child: Text(card.storageId.toString()))
        //   ],
        // ),
        // TableRow(
        //   children: [
        //     const TableCell(child: Text("Verfuegbar:")),
        //     TableCell(
        //       child: Text(
        //         card.isAvailable.toString(),
        //         style: TextStyle(
        //             color: colorAvailable, fontWeight: FontWeight.bold),
        //       ),
        //     )
        //   ],
        // )
      ],
    ),
  );
}

Widget buildBottomButton(BuildContext context, String site, Cards card) {
  switch (site) {
    case 'cards':
      //@TODO only get cards that are available
      Widget getNow = const SizedBox(
        width: 0,
        height: 0,
      );
      return Row(
        children: [
          Expanded(
            //get card
            child: CardButton(
                text: 'Jetzt holen',
                onPress: () {
                  MqttTimer.startTimer(context, "to-get-card");
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => MqttTimer(
                  //         message: "Halten Sie Ihre Karte an den Sensor!"),
                  //   ),
                  // );
                }),
          ),
          SizedBox(
            width: 1,
            height: 50,
            child: Container(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ],
      );
  }
  return const SizedBox();
}
