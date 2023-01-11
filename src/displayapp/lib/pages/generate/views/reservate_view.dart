import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/reservation.dart';
import 'package:rfidapp/provider/types/storage.dart';

class ReservateView extends StatelessWidget {
  final Storage storage;
  final BuildContext context;
  final String searchstring;

  ReservateView(
      {Key? key,
      required this.storage,
      required this.context,
      required this.searchstring});

  @override
  Widget build(BuildContext context) {
    if (storage.cards == null) {
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
            card = reservations[index].user.email.contains(searchstring);
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

          columnWidths: const <int, TableColumnWidth>{
            0: FractionColumnWidth(0.2),
            1: FractionColumnWidth(0.7),
          },

          children: [
            TableRow(
              children: [
                const TableCell(child: Text("Karte:")),
                TableCell(child: Text(reserveration.cardName.toString()))
              ],
            ),
            TableRow(
              children: [
                const TableCell(child: Text("Email:")),
                TableCell(child: Text(reserveration.user.email.toString()))
              ],
            ),
            TableRow(
              children: [
                const TableCell(child: Text("Von:")),
                TableCell(
                  child: Text(
                    DateTime.fromMillisecondsSinceEpoch(
                            reserveration.since * 1000)
                        .toString(),
                    style: const TextStyle(color: Colors.green),
                  ),
                )
              ],
            ),
            TableRow(
              children: [
                const TableCell(child: Text("Bis:")),
                TableCell(
                  child: Text(
                    DateTime.fromMillisecondsSinceEpoch(reserveration.until)
                        .toString(),
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
    for (var element in storage.cards!) {
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
