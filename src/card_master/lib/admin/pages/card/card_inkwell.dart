import 'package:card_master/admin/provider/middelware.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/card/card_table.dart';
import 'package:card_master/admin/pages/card/alert_dialog.dart';

class GenerateCard extends StatefulWidget {
  final IconData icon;
  final String route;
  final Cards card;
  final String storageName;

  const GenerateCard({
    Key? key,
    required this.icon,
    required this.route,
    required this.card,
    required this.storageName,
  }) : super(key: key);

  @override
  State<GenerateCard> createState() => _GenerateCardState();
}

class _GenerateCardState extends State<GenerateCard> {
  String availableTranslated = "";

  @override
  void initState() {
    super.initState();
    translate();
  }

  void translate() {
    if (widget.card.available) {
      availableTranslated = "Ja";
    } else {
      availableTranslated = "Nein";
    }
  }

  Color getColor() {
    if (widget.card.available) {
      setState(() {});
      return Colors.green;
    } else {
      setState(() {});
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: InkWell(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    right: BorderSide(
                      color: getColor(),
                      width: 10,
                    ),
                  )),
                  padding: const EdgeInsets.all(15),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 0,
                        right: 15,
                      ),
                      child: Icon(widget.icon, size: 50),
                    ),
                    Expanded(
                        child: createCardTable(
                      context,
                      widget.card.name,
                      widget.storageName,
                      widget.card.accessed,
                      availableTranslated,
                    )),
                  ])),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => buildAlertDialog(
                          context,
                          "Karte bearbeiten ...",
                          "Sie könnnen folgende Änderungen an der Karte vornehmen: ",
                          [
                            generateButtonRectangle(
                              context,
                              "Karte bearbeiten",
                              () {
                                Navigator.of(context).pushNamed(
                                  widget.route,
                                  arguments: widget.card.name,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            generateButtonRectangle(
                              context,
                              "Karte löschen",
                              () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        buildAlertDialog(
                                          context,
                                          "Karte löschen ...",
                                          "Wollen Sie diese Karte löschen?",
                                          [
                                            generateButtonRectangle(
                                                context, "Ja", () async {
                                              await Data.checkAuthorization(
                                                  function: deleteCard,
                                                  context: context,
                                                  args: {
                                                    "name": widget.card.name,
                                                    'data': []
                                                  });
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            }),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            generateButtonRectangle(
                                              context,
                                              "Nein",
                                              () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ));
                              },
                            )
                          ],
                        ));
              },
            )));
  }
}
