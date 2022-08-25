import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';
import 'package:rfidapp/pages/navigation/menu_navigation.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'dart:async';
import 'dart:convert';

import 'package:rfidapp/provider/restApi/data.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPage();
}

class _CardPage extends State<CardPage> {
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
          title: Text('Karten',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor))),
      body: Center(child: ApiVisualizer.build(context, "cards")),
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
