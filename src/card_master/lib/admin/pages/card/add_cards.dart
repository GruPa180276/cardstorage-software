import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/pages/card/form.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/focus.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/pages/card/timer_dialog.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/card/storage_selector.dart';

class AddCards extends StatefulWidget {
  const AddCards({Key? key}) : super(key: key);

  @override
  State<AddCards> createState() => _AddCardsState();
}

class _AddCardsState extends State<AddCards> {
  List<String> listOfStorageNames = [];
  List<Storages> listOfStorages = [];
  List<Cards> listOfCards = [];
  List<FocusS> listUnfocusedStorages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
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
          "Karte hinzufügen",
          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Column(
        children: [
          GenerateCards(
            listOfCards: listOfCards,
            listOfStorageNames: listOfStorageNames,
            listOfStorages: listOfStorages,
          )
        ],
      ),
    );
  }
}

class GenerateCards extends StatefulWidget {
  final List<String> listOfStorageNames;
  final List<Storages> listOfStorages;
  final List<Cards> listOfCards;

  const GenerateCards({
    Key? key,
    required this.listOfStorageNames,
    required this.listOfCards,
    required this.listOfStorages,
  }) : super(key: key);

  @override
  State<GenerateCards> createState() => _GenerateCardsState();
}

class _GenerateCardsState extends State<GenerateCards> {
  String selectedStorage = "-";
  Cards card = Cards(
    name: "",
    storage: "",
    position: 0,
    accessed: 0,
    available: false,
    reader: "",
  );

  @override
  void initState() {
    super.initState();
  }

  void setCardName(String value) {
    card.name = value;
  }

  void setSelectedStorage(String value) {
    setState(() {
      selectedStorage = value;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: card.name);
    final formKey = GlobalKey<FormState>();

    return Expanded(
        child: Column(
      children: [
        buildCardForm(context, "Karte hinzufügen", (() async {
          if (formKey.currentState!.validate() && selectedStorage != "-") {
            Cards newEntry = Cards(
              name: card.name,
              storage: selectedStorage,
              position: card.position,
              accessed: card.accessed,
              available: card.available,
              reader: "",
            );

            await Data.checkAuthorization(
                function: addCard,
                context: context,
                args: {"name": newEntry.name, 'data': newEntry.toJson()});

            int count = 0;

            var response = await Data.checkAuthorization(
                context: context,
                function: getAllCardsPerStorage,
                args: {"name": newEntry.storage});
            var temp = jsonDecode(response!.body);
            Storages storage = Storages.fromJson(temp);

            count = 0;

            setState(() {
              for (int i = 0; i < storage.cards.length; i++) {
                if (storage.cards[i].available == true) {
                  count++;
                }
              }
            });

            if (count != storage.numberOfCards) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      buildTimerdialog(context, newEntry));
            }
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
                  if (widget.listOfCards[i].name == value) {
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
    ));
  }
}
