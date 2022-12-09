// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardsSiteEnum.dart';
import 'package:rfidapp/pages/generate/widget/bottomSheet.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/pages/generate/views/card_view.dart';
import 'package:rfidapp/domain/app_preferences.dart';

// ignore: must_be_immutable
class ApiVisualizer extends StatefulWidget {
  CardPageTypes site;
  ApiVisualizer({super.key, required this.site});

  @override
  // ignore: no_logic_in_create_state
  State<ApiVisualizer> createState() => _ApiVisualizerState(site: site);
}

class _ApiVisualizerState extends State<ApiVisualizer> {
  _ApiVisualizerState({required this.site});
  Future<List<Cards>>? listOfTypes;
  Future<List<Cards>>? listOfTypesSinceInit;
  Set<String>? pinnedCards;

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  CardPageTypes site;

  @override
  void initState() {
    super.initState();
    reloadCardList();
    reloadPinnedList();
  }

  void reloadPinnedList() {
    setState(() {
      pinnedCards = AppPreferences.getCardsPinned();
    });
  }

  void reloadCardList() {
    setState(() {
      pinnedCards = AppPreferences.getCardsPinned();

      listOfTypes = Data.getCardsData();
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
    Widget seachField = const SizedBox(height: 0, width: 0);

    if (site != CardPageTypes.Favoriten) {
      seachField = Row(
        children: [
          Expanded(
            child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Karte suchen per Name',
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
            title: Text(site.toString().replaceAll("CardPageTypes.", ""),
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor))),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              seachField,
              const SizedBox(height: 10),
              FutureBuilder<List<Cards>>(
                future: listOfTypes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
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
                          case CardPageTypes.Reservierungen:
                            return cardsView(users, context, site,
                                pinnedCards!, reloadPinnedList, searchString);
                          case CardPageTypes.Karten:
                            return cardsView(users, context, site,
                                pinnedCards!, reloadPinnedList, searchString);
                          case CardPageTypes.Favoriten:
                            return cardsView(users, context, site,
                                pinnedCards!, reloadPinnedList, searchString);
                        }
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


