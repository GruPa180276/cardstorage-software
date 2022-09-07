import 'package:admin_login/pages/widget/customsearchdelegate.dart';
import 'package:flutter/material.dart';

Expanded generateSearchButton(
    BuildContext context, Function setID, List<String> searchValues) {
  return Expanded(
      child: FloatingActionButton.extended(
    icon: Icon(
      Icons.search,
      color: Theme.of(context).focusColor,
    ),
    label: Text("Karte Suchen",
        style: TextStyle(color: Theme.of(context).focusColor)),
    backgroundColor: Theme.of(context).secondaryHeaderColor,
    onPressed: () {
      showSearch(
          context: context,
          delegate: CustomSearchDelegate(setID, searchValues));
    },
  ));
}
