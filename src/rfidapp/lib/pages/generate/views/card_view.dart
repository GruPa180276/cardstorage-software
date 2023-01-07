import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/TimerActions.dart';
import 'package:rfidapp/pages/generate/widget/mqtt_timer.dart';
import 'package:rfidapp/pages/generate/widget/createCardButton.dart';
import 'package:rfidapp/provider/types/readercards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class CardView extends StatelessWidget {
  List<Storage> storages;
  BuildContext context;
  String searchstring;

  CardView(
      {Key? key,
      required this.storages,
      required this.context,
      required this.searchstring});

  @override
  Widget build(BuildContext context) {
    if (storages == null) {
      return const Text("Error");
    }
    var readercards = _parseToCardsList();

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
                      _buildCardsButton(context, readercards[index])
                    ]))
                : Container();
          }),
    );
  }

  static Widget _buildCardsText(BuildContext context, ReaderCard card) {
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

  static Widget _buildCardsButton(BuildContext context, ReaderCard card) {
    if (!card.available) {
      return Container();
    }
    return Row(
      children: [
        Expanded(
          //get card
          child: CardButton(
              text: 'Jetzt holen',
              onPress: () {
                MqttTimer(context: context, action: TimerAction.GETCARD)
                    .startTimer();
              }),
        )
      ],
    );
  }

  List<ReaderCard> _parseToCardsList() {
    //@TODO if not reserveraetion (is currently in use)
    List<ReaderCard> cards = List.empty(growable: true);
    for (var element in storages) {
      if (element.cards == null) {
        continue;
      }
      cards = cards + element.cards!;
    }
    return cards;
  }
}
