import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'dart:async';
import 'dart:convert';

import 'package:rfidapp/provider/restApi/data.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({Key? key}) : super(key: key);

  @override
  State<ReservatePage> createState() => _ReservatePageState();
}

class _ReservatePageState extends State<ReservatePage> {
  Future<List<Cards>>? listOfCards;

  @override
  void initState() {
    super.initState();
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      listOfCards = Data.getData("card").then((value) =>
          jsonDecode(value.body).map<Cards>(Cards.fromJson).toList());
      ApiVisualizer.listOfTypes = listOfCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 125,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text('Ihre Reservierungen',
            style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 35,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor)),
      ),
      body: Center(child: ApiVisualizer.build(context, "reservation")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        child: const Icon(
          Icons.replay,
          color: Colors.white,
        ),
        onPressed: () => {reloadCardList()},
      ),
    );
  }
}
