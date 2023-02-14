import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/card/search.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/card/card_builder.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/pages/card/storage_selector.dart';

import '../../provider/middelware.dart';

class CardsView extends StatefulWidget {
  const CardsView({Key? key}) : super(key: key);

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  String selectedStorage = "-";
  List<String> listOfStorageNames = [];
  List<Storages> listOfStorages = [];
  List<Storages> filteredStorages = [];

  TextEditingController txtQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await Data.checkAuthorization(
        context: context, function: fetchStorages);

    // await fetchStorages().then((value) => listOfStorages = value);
    var temp = jsonDecode(response!.body) as List;

    listOfStorages = temp.map((e) => Storages.fromJson(e)).toList();

    await Data.checkAuthorization(
        function: updateCard,
        context: context,
        args: {"name": "card1", 'card': []});

    listOfStorageNames.add("-");
    for (int i = 0; i < listOfStorages.length; i++) {
      listOfStorageNames.add(listOfStorages[i].name);
    }

    filteredStorages = listOfStorages;
    setState(() {});
  }

  void search(String query) {
    if (query.isEmpty) {
      listOfStorageNames.clear();
      fetchData();
      setState(() {});
      return;
    }

    query = query.toLowerCase();

    for (int i = 0; i < filteredStorages.length; i++) {
      List<Cards> tmp = [];
      for (int j = 0; j < filteredStorages[i].cards.length; j++) {
        var name = filteredStorages[i].cards[j].name.toString().toLowerCase();
        if (name.contains(query)) {
          tmp.add(filteredStorages[i].cards[j]);
        }
      }
      filteredStorages[i].cards = tmp;
    }

    setState(() {});
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
      floatingActionButton: GenerateReloadButton(fetchData),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          buildSeacrh(context, txtQuery, search),
                          const SizedBox(
                            width: 10,
                          ),
                          buildStorageSelector(
                            context,
                            selectedStorage,
                            listOfStorageNames,
                            setSelectedStorage,
                            "Filter",
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Column(children: <Widget>[
                ListCards(
                  selectedStorage: selectedStorage,
                  listOfStorages: filteredStorages,
                )
              ]),
            ),
          ])),
    );
  }
}
