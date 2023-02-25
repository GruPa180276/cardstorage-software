import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/reservations.dart';
import 'package:card_master/admin/pages/reservation/reservation_inkwell.dart';

class ListReservations extends StatefulWidget {
  final List<ReservationOfCards> listOfCardReservations;

  const ListReservations({
    Key? key,
    required this.listOfCardReservations,
  }) : super(key: key);

  @override
  State<ListReservations> createState() => _ListReservationsState();
}

class _ListReservationsState extends State<ListReservations> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: widget.listOfCardReservations.length,
            itemBuilder: (context, index) {
              return GenerateReservation(
                icon: Icons.storage,
                reservationOfCards: widget.listOfCardReservations[index],
              );
            }));
  }
}
