import 'package:card_master/client/pages/widgets/inherited/card_inherited.dart';
import 'package:card_master/client/pages/widgets/widget/buttons/email_button.dart';
import 'package:card_master/client/pages/widgets/card/favorite_button.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';

import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  TextView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = CardData.of(context)!;

    var textFontSize = 2.1.fs;
    //var sizedBoxHeight = 2.9.hs;
    //horizontal: 35.0, vertical: 2.0
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(5.0.ws, 1.0.hs, 3.0.ws, 0.0.hs),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 1.0.hs, 12.0.ws, 0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(0.4),
                  1: FlexColumnWidth(0.35),
                },
                //border
                children: [
                  TableRow(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(
                            "Name:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(data.card.name,
                              style: TextStyle(fontSize: textFontSize),
                              textAlign: TextAlign.left))
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(
                            "Tresor:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(data.card.storageName!,
                              style: TextStyle(fontSize: textFontSize),
                              textAlign: TextAlign.left))
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(
                            "Verfügbar:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        width: double.infinity,
                        //height: sizedBoxHeight,
                        child: Text(
                          data.card.available.toString(),
                          style: TextStyle(
                              fontSize: textFontSize,
                              color: (!data.card.available)
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(
                            "Position:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        width: double.infinity,
                        //height: sizedBoxHeight,
                        child: Text(
                          data.card.position.toString(),
                          style: TextStyle(fontSize: textFontSize),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FavoriteButton(
                    card: data.card,
                    reloadPinned: data.reloadPinned,
                    pinnedCards: data.pinnedCards),
                EmailButton(card: data.card)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
