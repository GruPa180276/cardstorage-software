import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/pages/card/storage_selector.dart';

class BuildAlterCardForm extends StatefulWidget {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final Function setCardName;
  final List<Cards> listOfCards;
  final String selectedStorage;
  final dynamic Function(String) setSelectedStorage;
  final List<String> listOfStorageNames;
  final Cards card;
  final String oldCardName;

  const BuildAlterCardForm({
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
    required this.oldCardName,
  }) : super(key: key);

  @override
  State<BuildAlterCardForm> createState() => _BuildAlterCardFormState();
}

class _BuildAlterCardFormState extends State<BuildAlterCardForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
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
      const SizedBox(
        height: 10,
      ),
      SizedBox(
          width: double.infinity,
          child: buildStorageSelector(
            context,
            widget.selectedStorage,
            widget.listOfStorageNames,
            widget.setSelectedStorage,
            "Selected Storage",
          )),
      const SizedBox(
        height: 10,
      ),
      generateButtonRectangle(
          context,
          "Karte hinzufügen",
          () => () async {
                if (widget.formKey.currentState!.validate() &&
                    widget.selectedStorage != "-") {
                  Cards updateEntry = Cards(
                    name: widget.card.name,
                    storage: widget.selectedStorage,
                    position: widget.card.position,
                    accessed: widget.card.accessed,
                    available: widget.card.available,
                    reader: widget.card.reader,
                  );

                  await Data.checkAuthorization(
                      function: deleteCard,
                      context: context,
                      args: {
                        "name": widget.oldCardName,
                      });

                  if (context.mounted) {
                    await Data.checkAuthorization(
                        function: addCard,
                        context: context,
                        args: {"data": updateEntry.toJson()});
                  }

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                }
              })
    ]));
  }
}
