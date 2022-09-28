// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/widget/bottomSheet.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/pages/generate/views/card_view.dart';
import 'package:rfidapp/domain/app_preferences.dart';

class ApiVisualizer extends StatefulWidget {
  String site;
  ApiVisualizer({super.key, required this.site});

  @override
  State<ApiVisualizer> createState() => _ApiVisualizerState(site: site);
}

class _ApiVisualizerState extends State<ApiVisualizer> {
  _ApiVisualizerState({required this.site});
  Future<List<Cards>>? listOfTypes;
  Future<List<Cards>>? listOfTypesSinceInit;
  List<String>? pinnedCards;

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  String site;

  @override
  void initState() {
    super.initState();
    reloadCardList();
    pinnedCards = AppPreferences.getCardsPinned();
    print(pinnedCards);
  }

  void reloadCardList() {
    setState(() {
      listOfTypes = Data.getData("card").then(
          (value) =>
              jsonDecode(value!.body).map<Cards>(Cards.fromJson).toList(),
          onError: (error) {});
      listOfTypesSinceInit = listOfTypes;
    });
  }

  void setListType(Future<List<Cards>> listOfTypeNew) {
    setState(() {
      listOfTypes = listOfTypeNew;
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
            title: Text(site,
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor))),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search Card',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Theme.of(context).dividerColor))),
                        onChanged: ((value) {
                          setState(() {
                            searchString = value;
                          });
                        })),
                  ),
                  IconButton(
                      onPressed: () {
                        BottomSheetPop(
                          onPressStorage: setListType,
                          listOfTypes: listOfTypesSinceInit!,
                        ).buildBottomSheet(context);
                      },
                      icon: const Icon(Icons.adjust))
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Cards>>(
                future: listOfTypes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                              'No connection was found. Please check if you are connected!'),
                        );
                      } else {
                        final users = snapshot.data!;

                        switch (site) {
                          //TODO change to required class
                          case "Reservierungen":
                            return cardsView(users, context, 'reservation',
                                pinnedCards!, searchString);
                          case "Karten":
                            return cardsView(users, context, 'cards',
                                pinnedCards!, searchString);
                        }
                        return const Text('Error Type not valid');
                      }
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: const Icon(
            Icons.replay,
            color: Colors.white,
          ),
          onPressed: () => {reloadCardList()},
        ));
  }
}


  //@TODO and voidCallback


