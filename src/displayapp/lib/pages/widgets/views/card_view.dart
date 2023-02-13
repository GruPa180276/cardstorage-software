import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enum/snackbar_type.dart';
import 'package:rfidapp/pages/widgets/inheritated/cards_inherited.dart';
import 'package:rfidapp/pages/widgets/pop_up/request_timer.dart';
import 'package:rfidapp/pages/widgets/pop_up/response_snackbar.dart';
import 'package:rfidapp/pages/widgets/widget/card_button.dart';
import 'package:rfidapp/provider/rest/types/cards.dart';
import 'package:rfidapp/provider/size/size_extentions.dart';

class CardView extends StatelessWidget {
  late CardViewData data;
  CardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    data = CardViewData.of(context)!;

    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: data.storage.cards!.length,
          itemBuilder: (context, index) {
            bool card = false;
            card = data.storage.cards![index].name.contains(data.searchstring);

            return card
                ? Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0.ws),
                    ),
                    child: Column(children: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0.ws, vertical: 2.0.hs),
                          child: Icon(Icons.credit_card_outlined, size: 5.0.fs),
                        ),
                        _buildCardsText(context, data.storage.cards![index]),
                      ]),
                      _buildCardsButton(
                          context, data.storage.cards![index], data.setState!)
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
    var fs = 1.75.hs;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 5.0.ws, 0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(0.4),
            1: FlexColumnWidth(0.35),
          },
          children: [
            TableRow(
              children: [
                SizedBox(
                  width: double.infinity,
                  //height: 25,
                  child: Text(
                    "Name:",
                    style: TextStyle(fontSize: fs),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  //height: 25,
                  child: Text(
                    style: TextStyle(fontSize: fs),
                    card.name,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                SizedBox(
                  width: double.infinity,
                  //height: 25,
                  child: Text(
                    style: TextStyle(fontSize: fs),
                    "Verfügbar:",
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  //height: 25,
                  child: Text(
                    card.available.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: colorAvailable,
                        fontWeight: FontWeight.bold,
                        fontSize: fs),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                SizedBox(
                  //height: 25,
                  child: Text(
                    "Position:",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: fs),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  //height: 25,
                  child: Text(
                    style: TextStyle(fontSize: fs),
                    card.position.toString(),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
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
                } catch (e) {
                  SnackbarBuilder(
                          context: context,
                          snackbarType: SnackbarType.failure,
                          header: "Verbindungsfehler!",
                          content: null)
                      .build();
                }
              }),
        )
      ],
    );
  }
}
