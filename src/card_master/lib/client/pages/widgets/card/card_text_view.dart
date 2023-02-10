import 'package:card_master/client/pages/widgets/inherited/cards_text_inherited.dart';
import 'package:card_master/client/pages/widgets/widget/buttons/email_button.dart';
import 'package:card_master/client/pages/widgets/card/favorite_button.dart';

import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  TextView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = CardTextData.of(context)!;
    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 70, 0),
            child: Table(
              //border: TableBorder.all(),

              children: [
                TableRow(
                  children: [
                    const SizedBox(
                        width: double.infinity,
                        height: 25,
                        child: Text(
                          "Name:",
                          textAlign: TextAlign.left,
                        )),
                    SizedBox(
                        width: double.infinity,
                        height: 25,
                        child: Text(data.card.name, textAlign: TextAlign.right))
                  ],
                ),
                TableRow(
                  children: [
                    const SizedBox(
                        width: double.infinity,
                        height: 25,
                        child: Text(
                          "Storage:",
                          textAlign: TextAlign.left,
                        )),
                    SizedBox(
                        width: double.infinity,
                        height: 25,
                        child: Text(data.card.storageName!,
                            textAlign: TextAlign.right))
                  ],
                ),
                TableRow(
                  children: [
                    const SizedBox(
                        width: double.infinity,
                        height: 25,
                        child: Text(
                          "Verfuegbar:",
                          textAlign: TextAlign.left,
                        )),
                    SizedBox(
                      width: double.infinity,
                      height: 25,
                      child: Text(
                        data.card.available.toString(),
                        style: TextStyle(
                            color: (!data.card.available)
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    const SizedBox(
                        width: double.infinity,
                        height: 25,
                        child: Text(
                          "Position:",
                          textAlign: TextAlign.left,
                        )),
                    SizedBox(
                      width: double.infinity,
                      height: 25,
                      child: Text(
                        data.card.position.toString(),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          FavoriteButton(
              card: data.card,
              reloadPinned: data.reloadPinned,
              pinnedCards: data.pinnedCards),
          EmailButton(card: data.card)
        ],
      ),
    );
  }
}
