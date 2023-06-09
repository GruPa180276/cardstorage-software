import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:sizer/sizer.dart';

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
  late Storages storage;

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
    var temp = jsonDecode(response!.body);
    storage = Storages.fromJson(temp);

    listOfCards = storage.cards;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SizerUtil.deviceType == DeviceType.mobile
          ? AppBar(
              toolbarHeight: 7.h,
              title: Text(
                "Statistiken",
                style: TextStyle(
                    color: Theme.of(context).focusColor, fontSize: 20.sp),
              ),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            )
          : AppBar(
              toolbarHeight: 8.h,
              title: Text(
                "Statistiken",
                style: TextStyle(
                    color: Theme.of(context).focusColor, fontSize: 18.sp),
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

    return SizerUtil.deviceType == DeviceType.mobile
        ? SingleChildScrollView(
            child: Container(
            height: 50.h,
            padding: const EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Wie oft wurde eine Karte ausgeborgt",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.sp),
                    ),
                    Expanded(
                        child: charts.BarChart(
                      series,
                      animate: true,
                    ))
                  ],
                ),
              ),
            ),
          ))
        : Container(
            height: 50.h,
            padding: const EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Wie oft wurde eine Karte ausgeborgt",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp),
                    ),
                    Expanded(
                        child: charts.BarChart(
                      series,
                      animate: true,
                    ))
                  ],
                ),
              ),
            ),
          );
  }
}
