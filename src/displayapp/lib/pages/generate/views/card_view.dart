import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/widget/mqtt_timer.dart';
import 'package:rfidapp/pages/generate/widget/createCardButton.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class CardView extends StatelessWidget {
  Storage storage;
  BuildContext context;
  String searchstring;

  CardView(
      {Key? key,
      required this.storage,
      required this.context,
      required this.searchstring});

  @override
  Widget build(BuildContext context) => Flexible(
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
                          _buildCardsText(context, storage.cards![index]),
                        ]),
                        _buildCardsButton(context, storage.cards![index])
                      ]))
                  : Container();
            }),
      );

  static Widget _buildCardsText(BuildContext context, ReaderCards card) {
    Color colorAvailable = Colors.green;
    if (!card.available) {
      colorAvailable = Colors.red;
    }
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
              const TableCell(child: Text("Name:")),
              TableCell(child: Text(card.name))
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

  static Widget _buildCardsButton(BuildContext context, ReaderCards card) {
    if (card.available) {
      return Container();
    }
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
}
