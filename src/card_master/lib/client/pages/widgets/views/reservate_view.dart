// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(children: [
                        Row(children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 30, 0),
                            child: Icon(Icons.credit_card_outlined, size: 35),
                          ),
                          _buildCardsText(context, reservations[index]),
                        ]),
                        _buildBottomCards(context, reservations[index])
                      ]))
                  : Container();
            }),
      );

  Widget _buildCardsText(BuildContext context, Reservation card) {
    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Table(
              //border: TableBorder.all(),

              columnWidths: const <int, TableColumnWidth>{
                0: FractionColumnWidth(0.59),
                1: FractionColumnWidth(0.4),
              },

              children: [
                TableRow(
                  children: [
                    const TableCell(child: Text("Name:")),
                    TableCell(child: Text(card.cardName!))
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("Storage:")),
                    TableCell(child: Text(card.storageName!))
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("Von:")),
                    TableCell(
                      child: Text(
                        DateFormat('yyyy-MM-dd HH:mm')
                            .format(DateTime.fromMicrosecondsSinceEpoch(
                                card.since * 1000000))
                            .toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("Bis:")),
                    TableCell(
                      child: Text(
                        (card.isreservation)
                            ? DateFormat('yyyy-MM-dd HH:mm')
                                .format(DateTime.fromMicrosecondsSinceEpoch(
                                    card.until * 1000000))
                                .toString()
                            : "In Benutzung",
                        style: const TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCards(BuildContext context, Reservation reservation) {
    return (reservation.isreservation)
        ? Row(
            children: [
              Expanded(
                  child: CardButton(
                onPress: () async {
                  var response = await Data.check(Data.deleteReservation,
                      {"reservationid": reservation.id.toString()});
                  if (response.statusCode != 200) {
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
          )
        : const SizedBox.shrink();
  }
}
