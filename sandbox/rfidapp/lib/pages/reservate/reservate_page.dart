import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';
import 'package:rfidapp/pages/navigation/menu_navigation.dart';
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
      drawer: const MenuNavigationDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: const Text('Ihre Reservierungen'),
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
