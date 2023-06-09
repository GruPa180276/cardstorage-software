import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/provider/types/focus.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/forms/alter_card_form.dart';
import 'package:sizer/sizer.dart';

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

    if (context.mounted) {
      var response = await Data.checkAuthorization(
          context: context, function: fetchStorages);
      var temp = jsonDecode(response!.body) as List;
      listOfStorages = temp.map((e) => Storages.fromJson(e)).toList();
    }

    if (context.mounted) {
      var resp = await Data.checkAuthorization(
          context: context, function: getAllUnfocusedStorages);

      var jsonResponse = json.decode(resp!.body) as List;
      listUnfocusedStorages =
          jsonResponse.map((data) => FocusS.fromJson(data)).toList();
    }

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
        appBar: SizerUtil.deviceType == DeviceType.mobile
            ? AppBar(
                toolbarHeight: 7.h,
                title: Text(
                  "Karte bearbeiten",
                  style: TextStyle(
                      color: Theme.of(context).focusColor, fontSize: 20.sp),
                ),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              )
            : AppBar(
                toolbarHeight: 8.h,
                title: Text(
                  "Karte bearbeiten",
                  style: TextStyle(
                      color: Theme.of(context).focusColor, fontSize: 18.sp),
                ),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              ),
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              BuildUpdateCard(
                listOfCards: listOfCards,
                card: card,
                listOfStorageNames: listOfStorageNames,
                oldCardName: widget.cardName,
              )
            ],
          ),
        ));
  }
}

class BuildUpdateCard extends StatefulWidget {
  final List<Cards> listOfCards;
  final List<String> listOfStorageNames;
  final Cards card;
  final String oldCardName;

  const BuildUpdateCard({
    Key? key,
    required this.listOfCards,
    required this.card,
    required this.listOfStorageNames,
    required this.oldCardName,
  }) : super(key: key);

  @override
  State<BuildUpdateCard> createState() => _BuildUpdateCardState();
}

class _BuildUpdateCardState extends State<BuildUpdateCard> {
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
          BuildAlterCardForm(
              listOfStorageNames: widget.listOfStorageNames,
              listOfCards: widget.listOfCards,
              context: context,
              formKey: formKey,
              nameController: nameController,
              setCardName: setCardName,
              selectedStorage: selectedStorage,
              setSelectedStorage: setSelectedStorage,
              card: widget.card,
              oldCardName: widget.oldCardName)
        ],
      ),
    );
  }
}
