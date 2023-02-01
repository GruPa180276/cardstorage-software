// ignore_for_file: deprecated_member_use, no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardpage_type.dart';
import 'package:rfidapp/pages/generate/views/reservate_view.dart';
import 'package:rfidapp/provider/connection/api/data.dart';
import 'package:rfidapp/provider/types/reservation.dart';

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
  late Future<List<Reservation>?> reservations;

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  CardPageTypes site;

  @override
  void initState() {
    super.initState();
    reloadReaderCards();
  }

  void reloadReaderCards() {
    setState(() {
      reservations = Data.getAllReservationUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget seachField = const SizedBox(height: 0, width: 0);

    if (site != CardPageTypes.Favoriten) {
      seachField = Row(
        children: [
          Expanded(
            child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Karte suchen per Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Theme.of(context).dividerColor))),
                onChanged: ((value) {
                  setState(() {
                    searchString = value;
                  });
                })),
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 100,
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text(site.toString().replaceAll("CardPageTypes.", ""),
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor))),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              seachField,
              const SizedBox(height: 10),
              FutureBuilder<List<Reservation>?>(
                future: reservations,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 2 - 200,
                              horizontal: 0),
                          child: Text(
                            'No connection was found. Please check if you are connected!',
                            style: TextStyle(
                                color: Theme.of(context).dividerColor,
                                fontSize: 20),
                          ),
                        );
                      } else if (snapshot.data == null) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 2 - 200,
                              horizontal: 0),
                          child: Text(
                            'No Data',
                            style: TextStyle(
                                color: Theme.of(context).dividerColor,
                                fontSize: 20),
                          ),
                        );
                      } else {
                        final cards = snapshot.data!;
                        return ReservationView(
                            reservations: cards,
                            context: context,
                            searchstring: searchString,
                            setState: setState);
                      }
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: const Icon(
            Icons.replay,
            color: Colors.white,
          ),
          onPressed: () => {reloadReaderCards()},
        ));
  }
}


  //@TODO and voidCallback


