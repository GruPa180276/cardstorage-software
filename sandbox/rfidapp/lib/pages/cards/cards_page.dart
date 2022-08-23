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
  Future<List<Cards>>? listOfUsers;

  @override
  void initState() {
    super.initState();
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      listOfUsers = FetchData.getData("posts").then((value) =>
          jsonDecode(value.body).map<Cards>(Cards.fromJson).toList());
      ListCards.listOfTypes = listOfUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuNavigationDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: const Text('Karten'),
      ),
      body: Center(child: ListCards.build(context)),
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
