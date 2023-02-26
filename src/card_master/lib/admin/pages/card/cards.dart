import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/pages/card/search.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/card/card_builder.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/pages/card/storage_selector.dart';
import 'package:sizer/sizer.dart';

class CardsView extends StatefulWidget {
  const CardsView({Key? key}) : super(key: key);

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  TextEditingController txtQuery = TextEditingController();
  late Future<List<Storages>> futureListOfStorages;
  late Future<List<Cards>> futureListOfCards;
  List<String> listOfStorageNames = [];
  List<Storages> listOfStorages = [];
  List<Cards> filteredCards = [];
  String selectedStorage = "-";

  @override
  void initState() {
    super.initState();
    load();
    doSearch("-");
  }

  void load() {
    futureListOfCards = fetchData();
    doSearch("-");
  }

  Future<List<Cards>> fetchData() async {
    var response = await Data.checkAuthorization(
      context: context,
      function: fetchStorages,
    );

    var jsonResponse = json.decode(response!.body) as List;
    listOfStorages = jsonResponse.map((e) => Storages.fromJson(e)).toList();

    listOfStorageNames.clear();

    listOfStorageNames.add("-");
    for (int i = 0; i < listOfStorages.length; i++) {
      listOfStorageNames.add(listOfStorages[i].name);
    }

    List<Cards> tmp = [];

    for (int i = 0; i < listOfStorages.length; i++) {
      List<Cards> ls = [];
      for (int j = 0; j < listOfStorages[i].cards.length; j++) {
        Cards c = listOfStorages[i].cards[j];
        c.storage = listOfStorages[i].name;
        ls.add(c);
      }
      tmp.addAll(ls);
    }

    filteredCards = tmp;

    setState(() {});

    return tmp;
  }

  void doSearch(String query) {
    futureListOfCards = search(query);
  }

  Future<List<Cards>> search(String query) async {
    if (query.isEmpty) {
      listOfStorageNames.clear();
      load();
      setState(() {});
      return futureListOfCards;
    }

    if (query == "-") {
      return futureListOfCards;
    }

    query = query.toLowerCase();

    List<Cards> tmp = [];

    for (int j = 0; j < filteredCards.length; j++) {
      var name = filteredCards[j].name.toString().toLowerCase();
      if (name.contains(query)) {
        tmp.add(filteredCards[j]);
      }
    }

    setState(() {});

    return tmp;
  }

  void setSelectedStorage(String storageName) {
    setState(() {
      selectedStorage = storageName;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GenerateReloadButton(load),
      appBar: generateAppBar(context),
      body: Container(
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          generateButtonRound(
                              context, "Hinzufügen", Icons.add, "/addCards"),
                        ],
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: buildSeacrh(context, txtQuery, doSearch)),
                          SizedBox(
                            width: 2.w,
                          ),
                          Expanded(
                              child: buildStorageSelector(
                            context,
                            selectedStorage,
                            listOfStorageNames,
                            setSelectedStorage,
                            "Filter",
                          )),
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Column(children: [
                ListCards(
                  selectedStorage: selectedStorage,
                  listOfCards: futureListOfCards,
                )
              ]),
            ),
          ])),
    );
  }
}
