import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/pages/card/search.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/time.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/provider/types/reservations.dart';
import 'package:card_master/admin/provider/types/cardReservation.dart';
import 'package:card_master/admin/pages/reservation/reservation_time.dart';
import 'package:card_master/admin/pages/reservation/reservation_builder.dart';

class Reservations extends StatefulWidget {
  const Reservations({Key? key}) : super(key: key);

  @override
  State<Reservations> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Reservations> {
  late ReservationTime resTime = ReservationTime(time: 0, unit: "hours");

  List<CardReservation> listOfReservations = [];
  List<ReservationOfCards> listOfFilteredReservations = [];
  TextEditingController txtQuery = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    var respons = await Data.checkAuthorization(
      context: context,
      function: getReservationLatestGetTime,
    );
    var tem = jsonDecode(respons!.body);
    resTime = ReservationTime.fromJson(tem);

    if (context.mounted) {
      var response = await Data.checkAuthorization(
        context: context,
        function: fetchReservations,
      );
      var temp = jsonDecode(response!.body) as List;
      listOfReservations =
          temp.map((e) => CardReservation.fromJson(e)).toList();
    }

    List<ReservationOfCards> tmp = [];

    for (int i = 0; i < listOfReservations.length; i++) {
      for (int j = 0; j < listOfReservations[i].reservation.length; j++) {
        ReservationOfCards of = listOfReservations[i].reservation[j];
        of.name = listOfReservations[i].name;
        tmp.add(of);
      }
    }

    listOfFilteredReservations = tmp;

    setState(() {});
  }

  void search(String query) async {
    if (query.isEmpty) {
      fetchData();
      setState(() {});
      return;
    }

    query = query.toLowerCase();

    List<ReservationOfCards> tmp = [];

    for (int i = 0; i < listOfReservations.length; i++) {
      for (int j = 0; j < listOfReservations[i].reservation.length; j++) {
        var name = listOfReservations[i].name.toString().toLowerCase();
        if (name.contains(query)) {
          tmp.add(listOfReservations[i].reservation[j]);
        }
      }
    }

    listOfFilteredReservations = tmp;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: resTime.time.toString());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        floatingActionButton: GenerateReloadButton(fetchData),
        appBar: AppBar(
          title: Text(
            "Reservierungen",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          buildSeacrh(context, txtQuery, search),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListReservationTime(
                        formKey: formKey,
                        nameController: nameController,
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Column(children: [
                ListReservations(
                  listOfCardReservations: listOfFilteredReservations,
                )
              ]),
            ),
          ]),
        ));
  }
}
