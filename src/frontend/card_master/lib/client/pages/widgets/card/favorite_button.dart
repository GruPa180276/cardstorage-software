// ignore_for_file: must_be_immutable

import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/persistent/app_preferences.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';

class FavoriteButton extends StatelessWidget {
  final ReaderCard card;
  Set<String>? pinnedCards;
  final Function reloadPinned;

  FavoriteButton(
      {super.key,
      required this.card,
      this.pinnedCards,
      required this.reloadPinned});

  @override
  Widget build(BuildContext context) {
    var colorPin = (pinnedCards!.contains(card.name.toString())
        ? Colors.yellow
        : Theme.of(context).primaryColor);

    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return Container(
        alignment: Alignment.centerRight,
        child: IconButton(
          padding: EdgeInsets.fromLTRB(0, 0.0.hs, 0.0, 0),
          onPressed: () {
            setState(
              () {
                if (!(pinnedCards!.contains(card.name.toString()))) {
                  colorPin = Colors.yellow;
                  AppPreferences.addCardPinned(card.name.toString());
                } else {
                  AppPreferences.removePinnedCardAt(card.name);

                  pinnedCards = AppPreferences.getCardsPinned();
                  colorPin = Theme.of(context).primaryColor;
                }
                reloadPinned();
              },
            );
          },
          icon: Icon(
            Icons.star,
            color: colorPin,
          ),
          iconSize: 4.0.hs,
          splashColor: Colors.transparent,
          splashRadius: 0.1,
        ),
      );
    });
  }
}
