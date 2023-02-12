import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rfidapp/pages/widgets/inheritated/cards_inherited.dart';
import 'package:rfidapp/provider/rest/types/reservation.dart';

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
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(children: [
                      Row(children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Icon(Icons.credit_card_outlined, size: 35),
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Table(
          //border: TableBorder.all(),

          columnWidths: const {
            0: FlexColumnWidth(0.4),
            1: FlexColumnWidth(0.35),
          },

          children: [
            TableRow(
              children: [
                const SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      "Karte:",
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      reserveration.cardName.toString(),
                      textAlign: TextAlign.right,
                    ))
              ],
            ),
            TableRow(
              children: [
                const SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      "Email:",
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
                      reserveration.user.email.toString(),
                      textAlign: TextAlign.right,
                    ))
              ],
            ),
            TableRow(
              children: [
                const SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
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
                    style: const TextStyle(color: Colors.green),
                  ),
                )
              ],
            ),
            TableRow(
              children: [
                const SizedBox(
                    width: double.infinity,
                    //height: 25,
                    child: Text(
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
                    style: const TextStyle(color: Colors.red),
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
