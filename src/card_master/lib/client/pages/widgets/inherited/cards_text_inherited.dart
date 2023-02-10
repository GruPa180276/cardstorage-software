import 'package:card_master/client/domain/enums/cardpage_type.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/pages/widgets/widget/app_bar.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';

class CardTextData extends InheritedWidget {
  final ReaderCard card;
  final Set<String> pinnedCards;
  final void Function() reloadPinned;

  const CardTextData(
    this.pinnedCards,
    this.reloadPinned, {
    Key? key,
    required this.card,
    required Widget child,
  }) : super(key: key, child: child);

  static CardTextData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CardTextData>();
  }

  @override
  bool updateShouldNotify(CardTextData oldWidget) {
    return card != oldWidget.card || pinnedCards != oldWidget.pinnedCards;
  }
}
