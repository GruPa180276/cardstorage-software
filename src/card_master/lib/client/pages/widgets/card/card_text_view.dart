import 'package:card_master/client/pages/widgets/inherited/cards_text_inherited.dart';
import 'package:card_master/client/pages/widgets/widget/buttons/email_button.dart';
import 'package:card_master/client/pages/widgets/card/favorite_button.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';

import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  TextView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = CardTextData.of(context)!;
    var textFontSize = 11.0.fs;
//horizontal: 35.0.fs, vertical: 2.0.fs
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 5.0.fs, 5.0.fs, 0),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.0.fs, 0, 35.0.fs, 0),
              child: Table(
                //border
                children: [
                  TableRow(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          height: 16.0.fs,
                          child: Text(
                            "Name:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                          width: double.infinity,
                          height: 16.0.fs,
                          child: Text(data.card.name,
                              style: TextStyle(fontSize: textFontSize),
                              textAlign: TextAlign.right))
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          height: 16.0.fs,
                          child: Text(
                            "Storage:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                          width: double.infinity,
                          height: 16.0.fs,
                          child: Text(data.card.storageName!,
                              style: TextStyle(fontSize: textFontSize),
                              textAlign: TextAlign.right))
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          height: 16.0.fs,
                          child: Text(
                            "Verfuegbar:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        width: double.infinity,
                        height: 16.0.fs,
                        child: Text(
                          data.card.available.toString(),
                          style: TextStyle(
                              fontSize: textFontSize,
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
                      SizedBox(
                          width: double.infinity,
                          height: 13.0.fs,
                          child: Text(
                            "Position:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        width: double.infinity,
                        height: 13.0.fs,
                        child: Text(
                          data.card.position.toString(),
                          style: TextStyle(fontSize: textFontSize),
                          textAlign: TextAlign.right,
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
