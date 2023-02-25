import 'package:card_master/admin/pages/card/alert_dialog.dart';
import 'package:card_master/admin/pages/user/user_table.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:card_master/admin/provider/types/user.dart';

class GenerateUser extends StatefulWidget {
  final IconData icon;
  final Users user;

  const GenerateUser({
    Key? key,
    required this.icon,
    required this.user,
  }) : super(key: key);

  @override
  State<GenerateUser> createState() => _GenerateUserState();
}

class _GenerateUserState extends State<GenerateUser> {
  String priviledgedTranslated = "";

  @override
  void initState() {
    super.initState();
    translate();
  }

  void translate() {
    if (widget.user.privileged) {
      priviledgedTranslated = "Ja";
    } else {
      priviledgedTranslated = "Nein";
    }
  }

  Color getColor() {
    if (widget.user.privileged) {
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
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 0,
                          right: 15,
                        ),
                        child: Icon(Icons.account_box_outlined, size: 50),
                      ),
                      Expanded(
                        child: createUserTable(
                          context,
                          widget.user,
                          priviledgedTranslated,
                        ),
                      ),
                    ])),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => buildAlertDialog(
                            context,
                            "Benutzer Einstellungen ...",
                            "Sie könnnen folgende Änderungen an einem Benutzer vornehmen: ",
                            [
                              generateButtonRectangle(
                                context,
                                "Benutzer zu Admin",
                                () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          buildAlertDialog(
                                            context,
                                            "Benutzer zu Admin ...",
                                            "Wollen Sie diesen Benutzer zu einem Admin machen?",
                                            [
                                              generateButtonRectangle(
                                                context,
                                                "Ja",
                                                () async {
                                                  Users user = Users(
                                                    email: widget.user.email,
                                                    storage:
                                                        widget.user.storage,
                                                    privileged: true,
                                                    reader: widget.user.reader,
                                                  );

                                                  Response? response1 =
                                                      await Data
                                                          .checkAuthorization(
                                                              context: context,
                                                              function:
                                                                  updateData,
                                                              args: {
                                                        "name":
                                                            widget.user.email,
                                                        'data': user.toJson(),
                                                      });

                                                  if (response1!.statusCode ==
                                                          200 &&
                                                      context.mounted) {
                                                    FeedbackBuilder(
                                                      context: context,
                                                      header: "Erfolgreich",
                                                      snackbarType:
                                                          FeedbackType.success,
                                                      content:
                                                          "Benutzer ist nun Admin!",
                                                    ).build();
                                                  }

                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              generateButtonRectangle(
                                                context,
                                                "Nein",
                                                () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ));
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              generateButtonRectangle(
                                context,
                                "Benutzer löschen",
                                () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          buildAlertDialog(
                                            context,
                                            "Benutzer löschen ...",
                                            "Wollen Sie diesen Benutzer löschen?",
                                            [
                                              generateButtonRectangle(
                                                  context, "Ja", () async {
                                                Response? response1 = await Data
                                                    .checkAuthorization(
                                                  context: context,
                                                  function: deleteUser,
                                                  args: {
                                                    "name": widget.user.email
                                                        .toString(),
                                                  },
                                                );

                                                if (response1!.statusCode ==
                                                        200 &&
                                                    context.mounted) {
                                                  FeedbackBuilder(
                                                    context: context,
                                                    header: "Erfolgreich",
                                                    snackbarType:
                                                        FeedbackType.success,
                                                    content:
                                                        "Benutzer wurde gelöscht!",
                                                  ).build();
                                                }

                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
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
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ));
                                },
                              )
                            ],
                          ));
                })));
  }
}
