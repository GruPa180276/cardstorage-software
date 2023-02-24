import 'package:card_master/admin/pages/card/alert_dialog.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/ping.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/createStatus.dart';
import 'package:http/http.dart';

class GenerateStatus extends StatefulWidget {
  final IconData icon;
  final String route;
  final Storages storage;

  const GenerateStatus({
    Key? key,
    required this.icon,
    required this.route,
    required this.storage,
  }) : super(key: key);

  @override
  State<GenerateStatus> createState() => _GenerateCardState();
}

class _GenerateCardState extends State<GenerateStatus> {
  late Ping ping;
  int count = 0;
  bool pingWorked = false;
  bool focus = true;

  @override
  void initState() {
    super.initState();
    getNumberOfCardsInStorage();
    pingNow();
  }

  void pingNow() async {
    var response = await Data.checkAuthorization(
      context: context,
      function: pingStorage,
      args: {
        "name": widget.storage.name,
      },
    );
    dynamic jsonResponse = json.decode(response!.body);
    ping = Ping.fromJson(jsonResponse);

    if (ping.time != 0) {
      setState(() {
        pingWorked = true;
      });
    }
  }

  void getNumberOfCardsInStorage() {
    count = 0;

    setState(() {
      for (int i = 0; i < widget.storage.cards.length; i++) {
        if (widget.storage.cards[i].available == true) {
          count++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;

    if (pingWorked == false) {
      color = Colors.red;
    }

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
                      color: color,
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
                        child: createStatus(
                      context,
                      pingWorked,
                      widget.storage.name,
                      count,
                      widget.storage.numberOfCards,
                    )),
                  ])),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => buildAlertDialog(
                          context,
                          "Storage Funktionen ...",
                          "Sie könnnen folgende Funktionen bei einem Storage verwenden: ",
                          [
                            generateButtonRectangle(
                              context,
                              "Focus",
                              () async {
                                Response? response =
                                    await Data.checkAuthorization(
                                        context: context,
                                        function: focusStorage,
                                        args: {
                                      "name": widget.storage.name,
                                    });

                                if (response!.statusCode == 200 &&
                                    context.mounted) {
                                  FeedbackBuilder(
                                    context: context,
                                    header: "Erfolgreich",
                                    snackbarType: FeedbackType.success,
                                    content: "Focus war erfolgreich!",
                                  ).build();
                                }

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            generateButtonRectangle(
                              context,
                              "Ping",
                              () async {
                                Response? response =
                                    await Data.checkAuthorization(
                                  context: context,
                                  function: pingStorage,
                                  args: {"name": widget.storage.name},
                                );

                                if (response!.statusCode == 200 &&
                                    context.mounted) {
                                  FeedbackBuilder(
                                    context: context,
                                    header: "Erfolgreich",
                                    snackbarType: FeedbackType.success,
                                    content: "Ping war erfolgreich!",
                                  ).build();
                                }

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            generateButtonRectangle(
                              context,
                              "Statistiken",
                              () {
                                Navigator.of(context).pushNamed(
                                  "/status",
                                  arguments: widget.storage.name,
                                );
                              },
                            )
                          ],
                        ));
              },
            )));
  }
}
