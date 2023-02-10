import 'package:card_master/client/pages/widgets/inherited/cards_text_inherited.dart';
import 'package:card_master/client/pages/widgets/card/card_text_view.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/pages/widgets/inherited/cards_inherited.dart';
import 'package:card_master/client/pages/widgets/widget/buttons/email_button.dart';
import 'package:card_master/client/pages/widgets/card/favorite_button.dart';
import 'package:card_master/client/pages/widgets/card/card_bottom_row.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';

class FavoriteView extends StatelessWidget {
  late CardViewData data;

  FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    data = CardViewData.of(context)!;

    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: data.readercards.length,
          itemBuilder: (context, index) {
            bool card = false;

            if (data.pinnedCards.isEmpty &&
                index == data.readercards.length - 1) {
              return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: (MediaQuery.of(context).size.height / 2) / 2,
                      horizontal: 0),
                  child: Text(
                    'Sie haben keine Favoriten',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20),
                  ),
                ),
              );
            }
            for (String id in data.pinnedCards) {
              card = (data.readercards[index].name.toString() == id);
              if (card) {
                break;
              }
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
                        CardTextData(data.pinnedCards, data.reloadPinned,
                            card: data.readercards[index], child: TextView())
                      ]),
                      ReaderCardButtons(
                        key: key,
                        card: data.readercards[index],
                        reloadCard: data.reloadPinned,
                        setState: data.setState,
                      )
                    ]))
                : Container();
          }),
    );
  }
}
