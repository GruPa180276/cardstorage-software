// ignore_for_file: deprecated_member_use, no_logic_in_create_state
import 'dart:convert';

import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/types/cardpage_type.dart';
import 'package:card_master/client/pages/widgets/views/reservate_view.dart';
import 'package:card_master/client/pages/widgets/widget/app_bar.dart';
import 'package:card_master/client/pages/widgets/widget/connection_status_textfield.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/client/provider/rest/types/reservation.dart';

// ignore: must_be_immutable
class ReservationVisualizer extends StatefulWidget {
  CardPageType site;
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
  CardPageType site;

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

    if (site != CardPageType.Favoriten) {
      seachField = Row(
        children: [
          Expanded(
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0.fs),
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Karte suchen per Name',
                    hintStyle: TextStyle(fontSize: 10.0.fs),
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

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0.fs), //height of appbar
          child: CustomAppBar(
              title: site.toString().replaceAll("CardPageType.", "")),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 15.0.fs, horizontal: 5.0.fs),
          child: Column(
            children: [
              seachField,
              SizedBox(height: 10.0.fs),
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


