import 'package:flutter/material.dart';

import 'dart:async';

import 'package:app/pages/widget/data.dart';
import 'package:app/pages/widget/card.dart';
import 'package:app/pages/widget/button.dart';
import 'package:app/pages/widget/appbar.dart';
import 'package:app/pages/widget/speeddial.dart';
import 'package:app/pages/widget/circularprogressindicator.dart';

// ToDo: Changed the API Calls to the actual API

class Tab3 extends StatefulWidget {
  Tab3({Key? key}) : super(key: key);

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  String selectedStorage = "1";
  List<String> dropDownValues = ['1', '2', '3'];

  callBack(String storage) {
    setState(() {
      selectedStorage = storage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GenerateSpeedDial(this.callBack),
        appBar: generateAppBar(context),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
              child: Row(
                children: [
                  generateButton(context, "Hinzufügen", Icons.add, "/addCards"),
                  SizedBox(
                    width: 10,
                  ),
                  generateButton(
                      context, "Entfernen", Icons.remove, "/removeCards")
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                  children: <Widget>[ListCards(cardStorage: selectedStorage)]),
            ))
          ]),
        ));
  }
}

class ListCards extends StatefulWidget {
  final String cardStorage;
  ListCards({Key? key, required this.cardStorage}) : super(key: key);

  @override
  State<ListCards> createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                if (widget.cardStorage == data![index].userId.toString()) {
                  return GenerateCards.withArguments(
                      index: index,
                      data: data,
                      icon: Icons.credit_card,
                      route: "/alterCards",
                      argument: data[index].id - 1);
                } else {
                  return const SizedBox.shrink();
                }
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
            child: Column(
          children: [generateProgressIndicator(context)],
        ));
      },
    ));
  }
}
