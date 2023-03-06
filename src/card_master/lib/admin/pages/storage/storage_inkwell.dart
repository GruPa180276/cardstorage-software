import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/card/alert_dialog.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/storage/storage_table.dart';
import 'package:sizer/sizer.dart';

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

  String translate() {
    if (widget.focusState) {
      return "Ja";
    } else {
      return "Nein";
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
              child: SizerUtil.deviceType == DeviceType.mobile
                  ? Container(
                      height: 16.5.h,
                      decoration: BoxDecoration(
                          border: Border(
                        right: BorderSide(
                          color: getColor(),
                          width: 2.w,
                        ),
                      )),
                      padding: const EdgeInsets.all(10),
                      child: buildWidgets(context))
                  : Container(
                      height: 22.h,
                      decoration: BoxDecoration(
                          border: Border(
                        right: BorderSide(
                          color: getColor(),
                          width: 2.w,
                        ),
                      )),
                      padding: const EdgeInsets.all(10),
                      child: buildWidgets(context)),
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
                            SizedBox(
                              height: 1.h,
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
                                            SizedBox(
                                              height: 1.h,
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

  Widget buildWidgets(BuildContext context) {
    return Row(children: [
      SizerUtil.deviceType == DeviceType.mobile
          ? Padding(
              padding: EdgeInsets.only(
                right: 10.sp,
              ),
              child: Icon(widget.icon, size: 40.sp),
            )
          : Padding(
              padding: EdgeInsets.only(
                right: 10.sp,
              ),
              child: Icon(widget.icon, size: 30.sp),
            ),
      Expanded(
          child: createStorageTable(
        context,
        widget.storage,
        translate(),
      )),
    ]);
  }
}
