import 'package:flutter/material.dart';
import 'package:rfidapp/provider/rest/types/storage.dart';

class CardViewData extends InheritedWidget {
  Storage storage;
  String searchstring;
  final Function? setState;

  CardViewData({
    Key? key,
    required this.storage,
    required this.searchstring,
    this.setState,
    required Widget child,
  }) : super(key: key, child: child);

  static CardViewData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CardViewData>();
  }

  @override
  bool updateShouldNotify(CardViewData oldWidget) {
    return storage != oldWidget.storage ||
        searchstring != (oldWidget).searchstring;
  }
}
