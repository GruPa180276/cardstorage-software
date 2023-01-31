import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/widget/request_timer.dart';
import 'package:rfidapp/pages/generate/widget/card_button.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CardView extends StatelessWidget {
  Storage storage;
  BuildContext context;
  String searchstring;
  final Function setState;
  CardView(
      {Key? key,
      required this.storage,
      required this.context,
      required this.searchstring,
      required this.setState});

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
                        _buildCardsButton(
                            context, storage.cards![index], setState)
                      ]))
                  : Container();
            }),
      );

  static Widget _buildCardsText(BuildContext context, ReaderCard card) {
    Color colorAvailable = Colors.green;
    if (!card.available) {
      colorAvailable = Colors.red;
    }
    return Container(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
        ),
      ),
    );
  }

  static Widget _buildCardsButton(
      BuildContext context, ReaderCard card, Function setState) {
    if (!card.available) {
      return Container();
    }
    return Row(
      children: [
        Expanded(
          //get card
          child: CardButton(
              text: 'Jetzt holen',
              onPress: () async {
                try {
                  var req = RequestTimer(context: context, card: card);
                  await req.build();
                  if (!req.getSuccessful()) {
                    setState(
                      () {
                        card.available = false;
                      },
                    );
                  }
                } catch (e) {}
              }),
        )
      ],
    );
  }
}
