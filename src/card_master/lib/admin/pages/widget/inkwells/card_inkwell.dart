import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/pages/widget/generate/button.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/tables/card_table.dart';
import 'package:card_master/admin/pages/widget/generate/alert_dialog.dart';
import 'package:sizer/sizer.dart';

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

  String translate() {
    if (widget.card.available) {
      return "Ja";
    } else {
      return "Nein";
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
                            SizedBox(
                              height: 1.h,
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
                                              if (widget.card.available) {
                                                Response? response1 = await Data
                                                    .checkAuthorization(
                                                        function: deleteCard,
                                                        context: context,
                                                        args: {
                                                      "name": widget.card.name,
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
                                                        "Karte wurde gelöscht!",
                                                  ).build();
                                                }

                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                }
                                              } else if (!widget
                                                  .card.available) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();

                                                FeedbackBuilder(
                                                  context: context,
                                                  header: "Error!",
                                                  snackbarType:
                                                      FeedbackType.failure,
                                                  content:
                                                      "Karte ist nicht im Storage!",
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
          child: createCardTable(
        context,
        widget.card,
        widget.storageName,
        translate(),
      )),
    ]);
  }
}
