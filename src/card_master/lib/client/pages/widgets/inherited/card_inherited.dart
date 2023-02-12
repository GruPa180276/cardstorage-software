import 'package:flutter/material.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';

class CardData extends InheritedWidget {
  final ReaderCard card;
  final Set<String> pinnedCards;
  final void Function() reloadPinned;
  void Function(void Function())? setState;

  CardData({
    Key? key,
    required this.pinnedCards,
    required this.reloadPinned,
    required this.card,
    this.setState,
    required Widget child,
  }) : super(key: key, child: child);

  static CardData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CardData>();
  }

  @override
  bool updateShouldNotify(CardData oldWidget) {
    return card != oldWidget.card || pinnedCards != oldWidget.pinnedCards;
  }
}
