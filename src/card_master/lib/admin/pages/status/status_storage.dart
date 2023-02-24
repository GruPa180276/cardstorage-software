import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/provider/types/storages.dart';

class StatusStorage extends StatefulWidget {
  final String name;

  const StatusStorage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<StatusStorage> createState() => _StatusStorageState();
}

class _StatusStorageState extends State<StatusStorage> {
  late List<Cards> listOfCards = [];

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  void fetchCards() async {
    var response = await Data.checkAuthorization(
        context: context,
        function: getAllCardsPerStorage,
        args: {
          "name": widget.name,
        });
    var temp = jsonDecode(response!.body) as List;
    listOfCards = temp.map((e) => Cards.fromJson(e)).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Statistiken",
          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Column(children: [
        DeveloperChart(
          listOfCards: listOfCards,
        ),
      ]),
    );
  }
}

class DeveloperChart extends StatelessWidget {
  final List<Cards> listOfCards;

  const DeveloperChart({
    required this.listOfCards,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Cards, String>> series = [
      charts.Series(
        id: "cards",
        data: listOfCards,
        domainFn: (Cards series, _) => series.name,
        measureFn: (Cards series, _) => series.accessed,
        colorFn: (Cards series, _) => charts.ColorUtil.fromDartColor(
            Theme.of(context).secondaryHeaderColor),
      )
    ];

    return Container(
      height: 300,
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: <Widget>[
              Text(
                "Wie oft wurde eine Karte ausgeborgt",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
