import 'package:flutter/material.dart';

import 'package:admin_login/provider/types/ping.dart';
import 'package:admin_login/provider/types/storages.dart' as storages;
import 'package:admin_login/provider/types/cards.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:admin_login/provider/types/storages.dart';

class StatusStorage extends StatefulWidget {
  final String name;

  StatusStorage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<StatusStorage> createState() => _StatusStorageState();
}

class _StatusStorageState extends State<StatusStorage> {
  late Storages storage;
  late List<Cards> listOfCards = [];
  late Ping ping;

  @override
  void initState() {
    super.initState();
    fetchCards();
    pingNow();
  }

  void pingNow() async {
    await pingStorage(widget.name).then((value) => ping = value);

    setState(() {});
  }

  void focus() {
    focusStorage(widget.name);
  }

  void fetchCards() async {
    await storages
        .getAllCardsPerStorage(widget.name)
        .then((value) => listOfCards = value.cards);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Statistiken",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            DeveloperChart(
              cards: listOfCards,
            ),
          ]),
        ));
  }
}

// ignore: must_be_immutable
class DeveloperChart extends StatelessWidget {
  late List<Cards> cards;

  DeveloperChart({required this.cards, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Cards, String>> series = [
      charts.Series(
        id: "cards",
        data: cards,
        domainFn: (Cards series, _) => series.name,
        measureFn: (Cards series, _) => series.accessed,
        colorFn: (Cards series, _) => charts.ColorUtil.fromDartColor(
            Theme.of(context).secondaryHeaderColor),
      )
    ];

    return Container(
      height: 300,
      padding: const EdgeInsets.all(25),
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
