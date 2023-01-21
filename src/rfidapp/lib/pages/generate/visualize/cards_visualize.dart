// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardpage_site.dart';
import 'package:rfidapp/pages/generate/views/favorite_view.dart';
import 'package:rfidapp/pages/generate/pop_up/bottom_filter.dart';
import 'package:rfidapp/provider/connection/api/data.dart';
import 'package:rfidapp/provider/types/readercard.dart';
import 'package:rfidapp/pages/generate/views/card_view.dart';
import 'package:rfidapp/domain/app_preferences.dart';
import 'package:rfidapp/provider/types/storage.dart';

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
  late Future<List<ReaderCard>?> defaultReaderCards;
  late Future<List<ReaderCard>?> modifiedReaderCards;
  Set<String>? pinnedCards;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  CardPageTypes site;

  @override
  void initState() {
    super.initState();
    reloadReaderCards();
    reloadPinnedList();
  }

  void reloadPinnedList() {
    setState(() {
      pinnedCards = AppPreferences.getCardsPinned();
    });
  }

  void reloadReaderCards() {
    setState(() {
      pinnedCards = AppPreferences.getCardsPinned();

      defaultReaderCards = Data.getReaderCards();
      modifiedReaderCards = defaultReaderCards;
    });
  }

  void setReaderCards(Future<List<ReaderCard>?> newStorageList) {
    setState(() {
      modifiedReaderCards = newStorageList;
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
                  setReaderCards: setReaderCards,
                  defaultCards: defaultReaderCards,
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
              FutureBuilder<List<ReaderCard>?>(
                future: modifiedReaderCards,
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
                      } else if (snapshot.data == null) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 2 - 200,
                              horizontal: 0),
                          child: Text(
                            'No Data',
                            style: TextStyle(
                                color: Theme.of(context).dividerColor,
                                fontSize: 20),
                          ),
                        );
                      } else {
                        final cards = snapshot.data!;
                        switch (site) {
                          case CardPageTypes.Karten:
                            return CardView(
                              context: context,
                              searchstring: searchString,
                              readercards: cards,
                              pinnedCards: pinnedCards!,
                              reloadPinned: reloadPinnedList,
                              reloadCard: reloadReaderCards,
                              setState: setState,
                            );
                          case CardPageTypes.Favoriten:
                            return FavoriteView(
                              cards: cards,
                              context: context,
                              pinnedCards: pinnedCards!,
                              reloadPinned: reloadPinnedList,
                              searchstring: searchString,
                              reloadCard: reloadReaderCards,
                            );

                          //users.map((e) => e.cards).toList()
                        }
                      }
                      return Text("Error");
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
          onPressed: () => {reloadReaderCards()},
        ));
  }
}


  //@TODO and voidCallback


