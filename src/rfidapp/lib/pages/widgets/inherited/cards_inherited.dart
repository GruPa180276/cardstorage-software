import 'package:flutter/material.dart';
import 'package:rfidapp/pages/widgets/widget/AppBar.dart';
import 'package:rfidapp/provider/rest/types/readercard.dart';

class CardViewData extends InheritedWidget {
  final List<ReaderCard> readercards;
  final String searchstring;
  final Set<String> pinnedCards;
  final void Function() reloadPinned;
  final void Function() reloadCard;
  final void Function(void Function()) setState;
  final CustomAppBar customAppBar;

  const CardViewData({
    Key? key,
    required this.customAppBar,
    required this.readercards,
    required this.searchstring,
    required this.pinnedCards,
    required this.reloadPinned,
    required this.reloadCard,
    required this.setState,
    required Widget child,
  }) : super(key: key, child: child);

  static CardViewData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CardViewData>();
  }

  @override
  bool updateShouldNotify(CardViewData oldWidget) {
    return readercards != oldWidget.readercards ||
        searchstring != oldWidget.searchstring ||
        pinnedCards != oldWidget.pinnedCards;
  }
}