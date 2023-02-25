import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/card/alert_dialog.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/storage/storage_table.dart';

class GenerateStorage extends StatefulWidget {
  final IconData icon;
  final String route;
  final Storages storage;
  final bool focusState;

  const GenerateStorage({
    Key? key,
    required this.icon,
    required this.route,
    required this.storage,
    required this.focusState,
  }) : super(key: key);

  @override
  State<GenerateStorage> createState() => _GenerateStorageState();
}

class _GenerateStorageState extends State<GenerateStorage> {
  String focusTranslated = "";

  @override
  void initState() {
    super.initState();
    translate();
  }

  void translate() {
    if (widget.focusState) {
      focusTranslated = "Ja";
    } else {
      focusTranslated = "Nein";
    }
  }

  Color getColor() {
    if (widget.focusState) {
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
                        child: createStorageTable(
                      context,
                      widget.storage,
                      focusTranslated,
                    )),
                  ])),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => buildAlertDialog(
                          context,
                          "Storage bearbeiten ...",
                          "Sie könnnen folgende Änderungen an dem Storage vornehmen: ",
                          [
                            generateButtonRectangle(
                              context,
                              "Storage bearbeiten",
                              () {
                                Navigator.of(context).pushNamed(widget.route,
                                    arguments: widget.storage.name);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            generateButtonRectangle(
                              context,
                              "Storage löschen",
                              () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        buildAlertDialog(
                                          context,
                                          "Storage löschen ...",
                                          "Wollen Sie diese Karte löschen?",
                                          [
                                            generateButtonRectangle(
                                                context, "Ja", () async {
                                              if (widget
                                                  .storage.cards.isEmpty) {
                                                Response? response1 = await Data
                                                    .checkAuthorization(
                                                  context: context,
                                                  function: deleteUser,
                                                  args: {
                                                    "name":
                                                        "${widget.storage.name.toString().toLowerCase()}@default.com",
                                                  },
                                                );

                                                if (context.mounted) {
                                                  Response? response2 =
                                                      await Data
                                                          .checkAuthorization(
                                                              function:
                                                                  deleteStorage,
                                                              context: context,
                                                              args: {
                                                        "name":
                                                            widget.storage.name,
                                                        'data': []
                                                      });

                                                  if (response1!.statusCode == 200 &&
                                                      response2!.statusCode ==
                                                          200 &&
                                                      context.mounted) {
                                                    FeedbackBuilder(
                                                      context: context,
                                                      header: "Erfolgreich",
                                                      snackbarType:
                                                          FeedbackType.success,
                                                      content:
                                                          "Storage wurde gelöscht!",
                                                    ).build();
                                                  }
                                                }

                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                }
                                              } else if (widget
                                                  .storage.cards.isNotEmpty) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();

                                                FeedbackBuilder(
                                                  context: context,
                                                  header: "Error!",
                                                  snackbarType:
                                                      FeedbackType.failure,
                                                  content:
                                                      "Bitte alle Karten löschen!",
                                                ).build();
                                              }
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
