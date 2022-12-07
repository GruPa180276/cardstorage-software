// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/pages/generate/widget/bottomSheet.dart';
import 'package:rfidapp/provider/mqtt/mqtt.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/theme_provider.dart';
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
  List<Cards>? asd;
  Set<String>? pinnedCards;
  late bool isDark;

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  String site;

  @override
  void initState() {
    super.initState();
    reloadCardList();
    reloadPinnedList();
    isDark = AppPreferences.getIsOn();
  }

  void reloadPinnedList() {
    setState(() {
      pinnedCards = AppPreferences.getCardsPinned();
    });
  }

  void reloadCardList() {
    setState(() {
      pinnedCards = AppPreferences.getCardsPinned();
      // listOfTypes = Data.getCardsData();
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
    Widget seachField = SizedBox(height: 0, width: 0);

    if (site != "Favoriten") {
      seachField = Row(
        children: [
          Expanded(
            child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Suche Karte mittels ID',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Theme.of(context).dividerColor))),
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
      );
    }

    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 100,
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Stack(
              children: [
                Text(site,
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 11, 0, 0),
                    alignment: Alignment.bottomRight,
                    child: buildChangeThemeMode(context)),
              ],
            )),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              seachField,
              const SizedBox(height: 10),
              FutureBuilder<List<Cards>>(
                future: Data.getCardsData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: const CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 2 - 200,
                              horizontal: 0),
                          child: Text(
                            'No connection was found. Please check if you are connected!',
                            style: TextStyle(
                                color: Theme.of(context).dividerColor,
                                fontSize: 20),
                          ),
                        );
                      } else {
                        final users = snapshot.data!;

                        switch (site) {
                          //TODO change to required class
                          case "Reservierung":
                            return cardsView(users, context, 'reservation',
                                pinnedCards!, reloadPinnedList, searchString);
                          case "Karten":
                            return cardsView(users, context, 'cards',
                                pinnedCards!, reloadPinnedList, searchString);
                          case "Favoriten":
                            return cardsView(users, context, 'favoriten',
                                pinnedCards!, reloadPinnedList, searchString);
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

  Widget buildChangeThemeMode(BuildContext context) {
    return Switch(
        activeColor: Theme.of(context).secondaryHeaderColor,
        value: isDark,
        onChanged: (value) async {
          await AppPreferences.setIsOn(value);
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          isDark = value;
          setState(() {
            provider.toggleTheme(value);
          });
        });
  }
}





  //@TODO and voidCallback


