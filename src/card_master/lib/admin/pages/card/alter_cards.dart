import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/pages/card/form.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/focus.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/card/storage_selector.dart';

class CardSettings extends StatefulWidget {
  const CardSettings({Key? key, required this.cardName}) : super(key: key);
  final String cardName;

  @override
  State<CardSettings> createState() => _CardSettingsState();
}

class _CardSettingsState extends State<CardSettings> {
  List<String> listOfStorageNames = [];
  List<Storages> listOfStorages = [];
  List<Cards> listOfCards = [];
  List<FocusS> listUnfocusedStorages = [];

  late Cards card = Cards(
    name: widget.cardName,
    storage: "",
    position: 0,
    accessed: 0,
    available: false,
    reader: "",
  );

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response1 =
        await Data.checkAuthorization(context: context, function: fetchCards);
    var temp1 = jsonDecode(response1!.body) as List;
    listOfCards = temp1.map((e) => Cards.fromJson(e)).toList();

    for (int i = 0; i < listOfCards.length; i++) {
      if (listOfCards[i].name == widget.cardName) {
        card = listOfCards[i];
      }
    }

    var response = await Data.checkAuthorization(
        context: context, function: fetchStorages);
    var temp = jsonDecode(response!.body) as List;
    listOfStorages = temp.map((e) => Storages.fromJson(e)).toList();

    var resp = await Data.checkAuthorization(
        context: context, function: getAllUnfocusedStorages);

    List jsonResponse = json.decode(resp!.body);
    listUnfocusedStorages =
        jsonResponse.map((data) => FocusS.fromJson(data)).toList();

    listOfStorageNames.add("-");
    for (int i = 0; i < listOfStorages.length; i++) {
      listOfStorageNames.add(listOfStorages[i].name);
    }

    for (int i = 0; i < listOfStorageNames.length; i++) {
      for (int j = 0; j < listUnfocusedStorages.length; j++) {
        if (listOfStorageNames[i] == listUnfocusedStorages[j].name) {
          listOfStorageNames.removeAt(i);
          setState(() {});
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Karte bearbeiten",
          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Column(
        children: [
          GenerateCards(
            listOfCards: listOfCards,
            card: card,
            listOfStorageNames: listOfStorageNames,
            oldCardName: widget.cardName,
          )
        ],
      ),
    );
  }
}

class GenerateCards extends StatefulWidget {
  final List<Cards> listOfCards;
  final List<String> listOfStorageNames;
  final Cards card;
  final String oldCardName;

  const GenerateCards({
    Key? key,
    required this.listOfCards,
    required this.card,
    required this.listOfStorageNames,
    required this.oldCardName,
  }) : super(key: key);

  @override
  State<GenerateCards> createState() => _GenerateCardsState();
}

class _GenerateCardsState extends State<GenerateCards> {
  String selectedStorage = "-";

  @override
  void initState() {
    super.initState();
  }

  void setCardName(String value) {
    widget.card.name = value;
  }

  void setSelectedStorage(String value) {
    setState(() {
      selectedStorage = value;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: widget.card.name);
    final formKey = GlobalKey<FormState>();

    return Expanded(
      child: Column(
        children: [
          buildCardForm(context, "Karte aktualisieren", (() async {
            if (formKey.currentState!.validate() && selectedStorage != "-") {
              Cards updateEntry = Cards(
                name: widget.card.name,
                storage: widget.card.storage,
                position: widget.card.position,
                accessed: widget.card.accessed,
                available: widget.card.available,
                reader: "",
              );

              await Data.checkAuthorization(
                  function: updateCard,
                  context: context,
                  args: {
                    "name": widget.card.name,
                    "data": updateEntry.toJson()
                  });
            }
          }),
              formKey,
              GenerateListTile(
                labelText: "Name",
                hintText: "",
                icon: Icons.storage,
                regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
                function: setCardName,
                controller: nameController,
                fun: (value) {
                  for (int i = 0; i < widget.listOfCards.length; i++) {
                    if (widget.listOfCards[i].name == widget.card.name) {
                      return null;
                    } else if (value!.isEmpty) {
                      return 'Bitte Name eingeben!';
                    } else if (widget.listOfCards[i].name == value) {
                      return 'Exsistiert bereits!';
                    }
                  }
                  if (value!.isEmpty) {
                    return 'Bitte Name eingeben!';
                  } else {
                    return null;
                  }
                },
              ),
              buildStorageSelector(
                context,
                selectedStorage,
                widget.listOfStorageNames,
                setSelectedStorage,
                "Selected Storage",
              ))
        ],
      ),
    );
  }
}
