import 'package:card_master/admin/provider/middelware.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/card/form.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/pages/card/alert_dialog.dart';

class CardSettings extends StatefulWidget {
  final String cardName;
  const CardSettings({
    Key? key,
    required this.cardName,
  }) : super(key: key);

  @override
  State<CardSettings> createState() => _CardSettingsState();
}

class _CardSettingsState extends State<CardSettings> {
  List<Cards> listOfCards = [];

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
    await fetchCards().then((value) => listOfCards = value);

    for (int i = 0; i < listOfCards.length; i++) {
      if (listOfCards[i].name == widget.cardName) {
        card = listOfCards[i];
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
      body: Column(children: [
        Expanded(
            child: Column(children: [
          GenerateCards(
            listOfCards: listOfCards,
            card: card,
          )
        ])),
      ]),
    );
  }
}

class GenerateCards extends StatefulWidget {
  final List<Cards> listOfCards;
  final Cards card;

  const GenerateCards({
    Key? key,
    required this.listOfCards,
    required this.card,
  }) : super(key: key);

  @override
  State<GenerateCards> createState() => _GenerateCardsState();
}

class _GenerateCardsState extends State<GenerateCards> {
  @override
  void initState() {
    super.initState();
  }

  void setCardName(String value) {
    widget.card.name = value;
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: widget.card.name);
    final formKey = GlobalKey<FormState>();

    return Expanded(
      child: Column(
        children: [
          buildCardForm(context, "Karte aktualisieren", (() async {
            if (formKey.currentState!.validate()) {
              Cards updateEntry = Cards(
                name: widget.card.name,
                storage: widget.card.storage,
                position: widget.card.position,
                accessed: widget.card.accessed,
                available: widget.card.available,
                reader: "",
              );

              int code = 200;

              Data.checkAuthorization(
                  function: updateCard,
                  context: context,
                  args: {
                    "name": widget.card.name,
                    'card': [updateEntry.toJson()]
                  });

              if (await code == 200) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) => buildAlertDialog(
                          context,
                          "Karte aktualisieren ...",
                          "Karte wurde Erfolgreich aktualisiert!",
                          [
                            generateButtonRectangle(
                              context,
                              "Ok",
                              () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ));
              }
              if (await code == 400) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => buildAlertDialog(
                          context,
                          "Karte aktualisieren ...",
                          "Es ist ein Fehler beim anlegen der Karte aufgetreten!",
                          [
                            generateButtonRectangle(
                              context,
                              "Ok",
                              () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ));
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
              const SizedBox.shrink())
        ],
      ),
    );
  }
}
