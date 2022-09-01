// ignore_for_file: deprecated_member_use
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/pages/generate/Widget/views/card_view.dart';

class ApiVisualizer extends StatefulWidget {
  String site;
  ApiVisualizer({super.key, required this.site});

  @override
  State<ApiVisualizer> createState() => _ApiVisualizerState(site: site);
}

class _ApiVisualizerState extends State<ApiVisualizer> {
  _ApiVisualizerState({required this.site});
  Future<List<Cards>>? listOfTypes;
  String searchString = "";
  TextEditingController searchController = TextEditingController();
  String site;

  @override
  void initState() {
    super.initState();
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      listOfTypes = Data.getData("card").then((value) =>
          jsonDecode(value.body).map<Cards>(Cards.fromJson).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text('Karten',
              style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor))),
      body: Column(
        children: [
          TextField(
              controller: searchController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Card',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Theme.of(context).dividerColor))),
              onChanged: ((value) {
                setState(() {
                  searchString = value;
                });
              })),
          SizedBox(height: 10),
          FutureBuilder<List<Cards>>(
            future: listOfTypes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                final users = snapshot.data!;

                switch (site) {
                  case "Reservierungen":
                    return cardsView(
                        users, context, 'reservation', searchString);
                  case "Karten":
                    return cardsView(users, context, 'cards', searchString);
                }
                return const Text('Error Type not valid');
              } else {
                return Text("${snapshot.error}");
              }
            },
          ),
        ],
      ),
    );
    floatingActionButton:
    FloatingActionButton(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      child: const Icon(
        Icons.replay,
        color: Colors.white,
      ),
      onPressed: () => {reloadCardList()},
    );
  }
}


  //@TODO and voidCallback


