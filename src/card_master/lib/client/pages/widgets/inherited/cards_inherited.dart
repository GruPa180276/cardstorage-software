import 'package:flutter/material.dart';

import 'package:card_master/client/provider/rest/types/readercard.dart';

class CardsData extends InheritedWidget {
  final List<ReaderCard> readercards;
  final String searchstring;
  final Set<String> pinnedCards;
  final void Function() reloadPinned;
  final void Function() reloadCard;
  final void Function(void Function()) setState;

  const CardsData({
    Key? key,
    required this.readercards,
    required this.searchstring,
    required this.pinnedCards,
    required this.reloadPinned,
    required this.reloadCard,
    required this.setState,
    required Widget child,
  }) : super(key: key, child: child);

  static CardsData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CardsData>();
  }

  @override
  bool updateShouldNotify(CardsData oldWidget) {
    return readercards != oldWidget.readercards ||
        searchstring != oldWidget.searchstring ||
        pinnedCards != oldWidget.pinnedCards;
  }
}
