// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:card_master/client/domain/local_notification.dart';
import 'package:card_master/client/pages/widgets/card/card_button.dart';
import 'package:card_master/client/provider/rest/data.dart';

import 'package:card_master/client/provider/rest/types/reservation.dart';

class ReservationView extends StatelessWidget {
  final List<Reservation> reservations;
  final BuildContext context;
  final void Function(void Function()) setState;

  final String searchstring;

  const ReservationView({
    super.key,
    required this.reservations,
    required this.context,
    required this.searchstring,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) => Flexible(
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              bool card = false;
              card = reservations[index].cardName!.contains(searchstring);
              return card
                  ? Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0.hs),
                      ),
                      child: Column(children: [
                        Row(children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(5.0.ws, 0, 0.0, 0),
                              child: Icon(Icons.credit_card_outlined,
                                  size: 6.0.hs)),
                          _buildCardsText(context, reservations[index]),
                        ]),
                        _buildBottomCards(context, reservations[index])
                      ]))
                  : Container();
            }),
      );

  Widget _buildCardsText(BuildContext context, Reservation card) {
    var textFontSize = 2.1.fs;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(5.0.ws, 0.0.hs, 3.0.ws, 0.0.hs),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 1.0.hs, 5.0.ws, (card.isreservation) ? 0 : 3.0.ws),
              child: Table(
                //border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(0.4),
                  1: FlexColumnWidth(0.55),
                },
                children: [
                  TableRow(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(
                            "Name:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(
                            card.cardName!,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: textFontSize),
                          ))
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                          //height: sizedBoxHeight,
                          width: double.infinity,
                          child: Text("Storage:",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: textFontSize))),
                      SizedBox(
                          width: double.infinity,
                          //height: sizedBoxHeight,
                          child: Text(card.storageName!,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: textFontSize)))
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                          //height: sizedBoxHeight,
                          width: double.infinity,
                          child: Text(
                            "Von:",
                            style: TextStyle(fontSize: textFontSize),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        width: double.infinity,
                        //height: sizedBoxHeight,
                        child: Text(
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(DateTime.fromMicrosecondsSinceEpoch(
                                  card.since * 1000000))
                              .toString(),
                          style: TextStyle(
                              color: Colors.red, fontSize: textFontSize),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                        //height: sizedBoxHeight,
                        width: double.infinity,
                        child: Text(
                          "Bis:",
                          style: TextStyle(fontSize: textFontSize),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        //height: sizedBoxHeight,
                        width: double.infinity,
                        child: Text(
                          (card.isreservation)
                              ? DateFormat('yyyy-MM-dd HH:mm')
                                  .format(DateTime.fromMicrosecondsSinceEpoch(
                                      card.until * 1000000))
                                  .toString()
                              : "In Benutzung",
                          style: TextStyle(
                              color: Colors.green, fontSize: textFontSize),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCards(BuildContext context, Reservation reservation) {
    return (reservation.isreservation)
        ? SizedBox(
            height: 7.0.hs,
            child: Row(
              children: [
                Expanded(
                    child: CardButton(
                  onPress: () async {
                    var response = await Data.checkAuthorization(
                        context: context,
                        function: Data.deleteReservation,
                        args: {"reservationid": reservation.id.toString()});
                    if (response!.statusCode != 200) {
                      var snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Etwas ist schiefgelaufen!',
                            message: response.statusCode.toString(),

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.failure,
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      var snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Reservierung wurde gelöscht!',
                            message: "",

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.success,
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        reservations.remove(reservation);
                      });
                      LocalNotificationService.cancel(reservation.since);
                    }
                  },
                  text: "Löschen",
                ))
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
