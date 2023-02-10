// ignore_for_file: deprecated_member_use, no_logic_in_create_state
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardpage_type.dart';
import 'package:rfidapp/pages/widgets/views/reservate_view.dart';
import 'package:rfidapp/pages/widgets/widget/AppBar.dart';
import 'package:rfidapp/pages/widgets/widget/connection_status_textfield.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/rest/types/reservation.dart';

// ignore: must_be_immutable
class ReservationVisualizer extends StatefulWidget {
  CardPageTypes site;
  ReservationVisualizer({super.key, required this.site});

  @override
  State<ReservationVisualizer> createState() =>
      _ReservationVisualizerState(site: site);
}

class _ReservationVisualizerState extends State<ReservationVisualizer> {
  _ReservationVisualizerState({required this.site});
  late Future<List<Reservation>?> _futureReservations;

  String _searchString = "";
  TextEditingController _searchController = TextEditingController();
  CardPageTypes site;

  @override
  void initState() {
    super.initState();
    _reloadReaderCards();
  }

  void _reloadReaderCards() async {
    setState(() {
      _futureReservations = _getReservations();
    });
  }

  Future<List<Reservation>?> _getReservations() async {
    var reservationsResponse =
        await Data.check(Data.getAllReservationUser, null);
    var jsonReservation = jsonDecode(reservationsResponse.body) as List;
    List<Reservation> reservations = jsonReservation
        .map((tagJson) => Reservation.fromJson(tagJson))
        .toList();
    return Future.value(reservations);
  }

  @override
  Widget build(BuildContext context) {
    Widget seachField = const SizedBox(height: 0, width: 0);

    if (site != CardPageTypes.Favoriten) {
      seachField = Row(
        children: [
          Expanded(
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Karte suchen per Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Theme.of(context).dividerColor))),
                onChanged: ((value) {
                  setState(() {
                    _searchString = value;
                  });
                })),
          ),
        ],
      );
    }
    CustomAppBar customAppBar =
        CustomAppBar(title: site.toString().replaceAll("CardPageTypes.", ""));
    return Scaffold(
        appBar: customAppBar,
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              seachField,
              const SizedBox(height: 10),
              FutureBuilder<List<Reservation>?>(
                  future: _futureReservations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const ConnectionStatusTextfield(
                        text: 'Keine Verbindung zum Server',
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const ConnectionStatusTextfield(
                        text: 'Keine Reservierungen vorhanden',
                      );
                    } else {
                      final cards = snapshot.data!;
                      return ReservationView(
                          reservations: cards,
                          context: context,
                          searchstring: _searchString,
                          setState: setState);
                    }
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: const Icon(
            Icons.replay,
            color: Colors.white,
          ),
          onPressed: () => {_reloadReaderCards()},
        ));
  }
}


  //@TODO and voidCallback

