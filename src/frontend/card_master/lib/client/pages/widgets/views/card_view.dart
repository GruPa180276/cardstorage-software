// ignore_for_file: must_be_immutable

import 'package:card_master/client/pages/widgets/inherited/card_inherited.dart';
import 'package:card_master/client/pages/widgets/card/card_text_view.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/pages/widgets/inherited/cards_inherited.dart';
import 'package:card_master/client/pages/widgets/card/card_bottom_row.dart';

class CardView extends StatelessWidget {
  late CardsData cardsData;

  CardView({super.key});
  @override
  Widget build(BuildContext context) {
    cardsData = CardsData.of(context)!;

    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: cardsData.readercards.length,
          itemBuilder: (context, index) {
            bool card = false;
            card = cardsData.readercards[index].name
                .contains(cardsData.searchstring);

            return card
                ? Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0.hs),
                    ),
                    child: Column(children: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0.ws, 0, 0.0, 0),
                          child: Icon(Icons.credit_card_outlined, size: 5.0.hs),
                        ),
                        //FavoriteView().buildCardsText(context, data.readercards[index]),
                        CardData(
                            pinnedCards: cardsData.pinnedCards,
                            reloadPinned: cardsData.reloadPinned,
                            card: cardsData.readercards[index],
                            child: const TextView())
                      ]),
                      CardData(
                          pinnedCards: cardsData.pinnedCards,
                          reloadPinned: cardsData.reloadPinned,
                          setState: cardsData.setState,
                          card: cardsData.readercards[index],
                          child: ReaderCardButtons())
                    ]))
                : Container();
          }),
    );
  }
}
