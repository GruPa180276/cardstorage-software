import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/card/alert_dialog.dart';
import 'package:card_master/admin/provider/types/reservations.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/admin/pages/reservation/reservation_table.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:sizer/sizer.dart';

class GenerateReservation extends StatefulWidget {
  final IconData icon;
  final ReservationOfCards reservationOfCards;

  const GenerateReservation({
    Key? key,
    required this.icon,
    required this.reservationOfCards,
  }) : super(key: key);

  @override
  State<GenerateReservation> createState() => _GenerateReservationState();
}

class _GenerateReservationState extends State<GenerateReservation> {
  String returnedTranslated = "";

  @override
  void initState() {
    super.initState();
    translate();
  }

  void translate() {
    if (widget.reservationOfCards.returnedAt > 0) {
      returnedTranslated = "Ja";
    } else {
      returnedTranslated = "Nein";
    }
  }

  Color getColor() {
    if (widget.reservationOfCards.returnedAt > 0) {
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
                        decoration: BoxDecoration(
                            border: Border(
                          right: BorderSide(
                            color: getColor(),
                            width: 2.w,
                          ),
                        )),
                        padding: const EdgeInsets.all(10),
                        child: Row(children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: 4.w,
                            ),
                            child: Icon(Icons.book, size: 50.sp),
                          ),
                          Expanded(
                            child: createReservationTable(
                              context,
                              widget.reservationOfCards,
                              widget.reservationOfCards.name,
                              returnedTranslated,
                            ),
                          ),
                        ]))
                    : Container(
                        decoration: BoxDecoration(
                            border: Border(
                          right: BorderSide(
                            color: getColor(),
                            width: 2.w,
                          ),
                        )),
                        padding: const EdgeInsets.all(10),
                        child: Row(children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: 4.w,
                            ),
                            child: Icon(Icons.book, size: 40.sp),
                          ),
                          Expanded(
                            child: createReservationTable(
                              context,
                              widget.reservationOfCards,
                              widget.reservationOfCards.name,
                              returnedTranslated,
                            ),
                          ),
                        ])),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => buildAlertDialog(
                            context,
                            "Reservierung Einstellungen ...",
                            "Sie könnnen folgende Änderungen an einer Reservierung vornehmen: ",
                            [
                              generateButtonRectangle(
                                context,
                                "Reservierung löschen",
                                () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          buildAlertDialog(
                                            context,
                                            "Reservierung löschen ...",
                                            "Wollen Sie diese Reservierung löschen?",
                                            [
                                              generateButtonRectangle(
                                                  context, "Ja", () async {
                                                Response? response1 = await Data
                                                    .checkAuthorization(
                                                        function:
                                                            deleteReservation,
                                                        context: context,
                                                        args: {
                                                      "name": widget
                                                          .reservationOfCards.id
                                                          .toString(),
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
                                                        "Reservierung wurde gelöscht!",
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
