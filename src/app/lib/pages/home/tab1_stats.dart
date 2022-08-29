import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:app/config/color_values/tab1_color_values.dart';
import 'package:app/config/text_values/tab1_text_values.dart';

// ToDo: The actual API values should be used

Tab1TextValues tab1statsTextProvider = new Tab1TextValues();
Tab1ColorProvider tab1statsColorProvider = new Tab1ColorProvider();

class CardStats extends StatefulWidget {
  const CardStats({Key? key}) : super(key: key);

  @override
  State<CardStats> createState() => _CardState();
}

class _CardState extends State<CardStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(tab1statsTextProvider.getAppTitle()),
          backgroundColor: Colors.blueGrey,
          actions: []),
      body: Column(children: [DeveloperChart()]),
    );
  }
}

class DeveloperChart extends StatelessWidget {
  const DeveloperChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DeveloperSeries, String>> series = [
      charts.Series(
          id: "developers",
          data: data,
          domainFn: (DeveloperSeries series, _) => series.year,
          measureFn: (DeveloperSeries series, _) => series.developers,
          colorFn: (DeveloperSeries series, _) => series.barColor)
    ];

    return Container(
      height: 300,
      padding: const EdgeInsets.all(25),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: <Widget>[
              Text("Test"),
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

class DeveloperSeries {
  final String year;
  final int developers;
  final charts.Color barColor;

  DeveloperSeries(
      {required this.year, required this.developers, required this.barColor});
}

final List<DeveloperSeries> data = [
  DeveloperSeries(
    year: "2017",
    developers: 40000,
    barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey),
  ),
  DeveloperSeries(
    year: "2018",
    developers: 5000,
    barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey),
  ),
  DeveloperSeries(
    year: "2019",
    developers: 40000,
    barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey),
  ),
  DeveloperSeries(
    year: "2020",
    developers: 35000,
    barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey),
  ),
  DeveloperSeries(
    year: "2021",
    developers: 45000,
    barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey),
  ),
];
