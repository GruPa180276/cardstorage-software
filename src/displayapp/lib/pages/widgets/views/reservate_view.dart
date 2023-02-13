import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rfidapp/pages/widgets/inheritated/cards_inherited.dart';
import 'package:rfidapp/provider/rest/types/reservation.dart';
import 'package:rfidapp/provider/size/size_extentions.dart';

class ReservateView extends StatelessWidget {
  late CardViewData data;

  ReservateView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    data = CardViewData.of(context)!;

    if (data.storage.cards == null) {
      return const Text("Error");
    }
    var reservations = _parseToReservationList();

    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            bool card = false;
            card = reservations[index].user.email.contains(data.searchstring);
            return card
                ? Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0.ws),
                    ),
                    child: Column(children: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0.ws, vertical: 2.0.hs),
                          child: Icon(Icons.credit_card_outlined, size: 5.0.fs),
                        ),
                        _buildCardsText(context, reservations[index]),
                      ]),
                    ]))
                : Container();
          }),
    );
  }

  static Widget _buildCardsText(
      BuildContext context, Reservation reserveration) {
    var fs = 1.75.hs;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 1.0.hs, 5.0.ws, 1.0.hs),
        child: Table(
          //border: TableBorder.all(),

          columnWidths: const {
            0: FlexColumnWidth(0.4),
            1: FlexColumnWidth(0.35),
          },

          children: [
            TableRow(
              children: [
                SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      "Karte:",
                      style: TextStyle(fontSize: fs),
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      style: TextStyle(fontSize: fs),
                      reserveration.cardName.toString(),
                      textAlign: TextAlign.right,
                    ))
              ],
            ),
            TableRow(
              children: [
                SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      "Email:",
                      style: TextStyle(fontSize: fs),
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      style: TextStyle(fontSize: fs),
                      reserveration.user.email.toString(),
                      textAlign: TextAlign.right,
                    ))
              ],
            ),
            TableRow(
              children: [
                SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      style: TextStyle(fontSize: fs),
                      "Von:",
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                  width: double.infinity,
                  //height: 25,
                  child: Text(
                    DateFormat('yyyy-MM-dd HH:mm')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            reserveration.since * 1000))
                        .toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.green, fontSize: fs),
                  ),
                )
              ],
            ),
            TableRow(
              children: [
                SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      style: TextStyle(fontSize: fs),
                      "Bis:",
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                  width: double.infinity,
                  //height: 25,
                  child: Text(
                    (reserveration.isreservation)
                        ? DateFormat('yyyy-MM-dd HH:mm')
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                reserveration.until * 1000))
                            .toString()
                        : "Wird benutzt",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.red, fontSize: fs),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Reservation> _parseToReservationList() {
    //@TODO if not reserveraetion (is currently in use)
    List<Reservation> reservations = List.empty(growable: true);
    for (var element in data.storage.cards!) {
      if (element.reservation == null) {
        break;
      }
      String name = element.name;
      for (var element in element.reservation!) {
        element.cardName = name;
        reservations.add(element);
      }
    }
    return reservations;
  }
}
