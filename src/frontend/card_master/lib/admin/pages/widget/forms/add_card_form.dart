import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/generate/button.dart';
import 'package:card_master/admin/pages/widget/generate/list_tile.dart';
import 'package:card_master/admin/pages/widget/generate/timer_dialog.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/generate/storage_selector.dart';
import 'package:sizer/sizer.dart';

class BuildAddCardForm extends StatefulWidget {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final Function setCardName;
  final List<Cards> listOfCards;
  final String selectedStorage;
  final dynamic Function(String) setSelectedStorage;
  final List<String> listOfStorageNames;
  final Cards card;

  const BuildAddCardForm({
    Key? key,
    required this.listOfStorageNames,
    required this.listOfCards,
    required this.context,
    required this.formKey,
    required this.nameController,
    required this.setCardName,
    required this.selectedStorage,
    required this.setSelectedStorage,
    required this.card,
  }) : super(key: key);

  @override
  State<BuildAddCardForm> createState() => _BuildAddCardFormState();
}

class _BuildAddCardFormState extends State<BuildAddCardForm> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Form(
            key: widget.formKey,
            child: Column(children: [
              GenerateListTile(
                labelText: "Name",
                hintText: "",
                icon: Icons.storage,
                regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
                function: widget.setCardName,
                controller: widget.nameController,
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
              SizedBox(
                height: 2.h,
              ),
              buildStorageSelector(
                context,
                widget.selectedStorage,
                widget.listOfStorageNames,
                widget.setSelectedStorage,
                "Selected Storage",
              ),
              const SizedBox(
                height: 10,
              ),
              generateButtonRectangle(context, "Karte hinzufügen", () async {
                if (widget.formKey.currentState!.validate() &&
                    widget.selectedStorage != "-") {
                  late Storages storage;

                  Cards newEntry = Cards(
                    name: widget.card.name,
                    storage: widget.selectedStorage,
                    position: widget.card.position,
                    accessed: widget.card.accessed,
                    available: widget.card.available,
                    reader: "",
                  );

                  await Data.checkAuthorization(
                      function: addCard,
                      context: context,
                      args: {"name": newEntry.name, 'data': newEntry.toJson()});

                  if (context.mounted) {
                    var response = await Data.checkAuthorization(
                        context: context,
                        function: getAllCardsPerStorage,
                        args: {"name": newEntry.storage});
                    var temp = jsonDecode(response!.body);
                    storage = Storages.fromJson(temp);
                  }

                  count = 0;

                  setState(() {
                    for (int i = 0; i < storage.cards.length; i++) {
                      if (storage.cards[i].available == true) {
                        count++;
                      }
                    }
                  });

                  if (count != storage.numberOfCards && context.mounted) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            buildTimerdialog(context, newEntry));
                  }
                }
              })
            ])));
  }
}
