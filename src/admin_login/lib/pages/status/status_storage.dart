import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
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
  }

  void focus() {
    focusStorage(widget.name);
  }

  void fetchCards() async {
    await storages
        .getAllCardsPerStorage(widget.name)
        .then((value) => listOfCards = value.cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Status Storage",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
              height: 70,
              padding: EdgeInsets.only(bottom: 5),
              child: Column(children: [
                generateButtonWithDialog(
                  context,
                  "Storage pingen",
                  (() {
                    pingNow();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: Text(
                                'Storage wird gepinged ...',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              content: new Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Der Storage " +
                                        ping.name +
                                        " wird gepinged ... \n\n" +
                                        "Benötigte Zeit: " +
                                        ping.time.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: 70,
                                  child: Column(children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Beenden",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).focusColor),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                              ],
                            ));
                  }),
                ),
              ]),
            ),
            Container(
              height: 70,
              padding: EdgeInsets.only(top: 5),
              child: Column(children: [
                generateButtonWithDialog(
                  context,
                  "Focus Storage",
                  (() {
                    focus();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: Text(
                                'Karte hinzufügen',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              content: new Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Der Storage " +
                                        widget.name +
                                        " wird ins System augneommen ...",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: 70,
                                  child: Column(children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Abschließen",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).focusColor),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                              ],
                            ));
                  }),
                ),
              ]),
            ),
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
