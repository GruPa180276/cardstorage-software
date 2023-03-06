import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:card_master/admin/pages/widget/generate/button.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/generate/list_tile.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/admin/pages/widget/generate/storage_selector.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';

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
          generateButtonRectangle(context, "Karte bearbeiten", () async {
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

              Response? response1 = await Data.checkAuthorization(
                  function: deleteCard,
                  context: context,
                  args: {
                    "name": widget.oldCardName,
                  });

              if (context.mounted) {
                Response? response2 = await Data.checkAuthorization(
                    function: addCard,
                    context: context,
                    args: {"data": updateEntry.toJson()});

                if (response1!.statusCode == 200 &&
                    response2!.statusCode == 200 &&
                    context.mounted) {
                  FeedbackBuilder(
                    context: context,
                    header: "Erfolgreich",
                    snackbarType: FeedbackType.success,
                    content: "Karte wurde bearbeitet!",
                  ).build();
                }
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
