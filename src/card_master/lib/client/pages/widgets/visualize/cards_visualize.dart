// ignore_for_file: deprecated_member_use
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:card_master/client/domain/enums/cardpage_type.dart';
import 'package:card_master/client/pages/navigation/bottom_navigation.dart';
import 'package:card_master/client/pages/widgets/inherited/cards_inherited.dart';
import 'package:card_master/client/pages/widgets/views/favorite_view.dart';
import 'package:card_master/client/pages/widgets/pop_up/bottom_filter.dart';
import 'package:card_master/client/pages/widgets/widget/app_bar.dart';
import 'package:card_master/client/pages/widgets/widget/connection_status_textfield.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/client/provider/rest/uitls.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';
import 'package:card_master/client/pages/widgets/views/card_view.dart';
import 'package:card_master/client/domain/app_preferences.dart';
import 'package:card_master/client/provider/rest/types/storage.dart';

// ignore: must_be_immutable
class ApiVisualizer extends StatefulWidget {
  CardPageType site;
  ApiVisualizer({super.key, required this.site});

  @override
  // ignore: no_logic_in_create_state
  State<ApiVisualizer> createState() => _ApiVisualizerState(site: site);
}

class _ApiVisualizerState extends State<ApiVisualizer> {
  _ApiVisualizerState({required this.site});
  late Future<List<ReaderCard>?> defaultReaderCards;
  late Future<List<ReaderCard>?> modifiedReaderCards;
  late double _heightBottomNavigation;
  Set<String>? pinnedCards;

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  CardPageType site;

  @override
  void initState() {
    super.initState();
    _reloadReaderCards();
    _reloadPinnedList();
    _heightBottomNavigation = context
        .findAncestorWidgetOfExactType<BottomNavigation>()!
        .preferredSize
        .height;
  }

  void _reloadPinnedList() {
    setState(() {
      pinnedCards = AppPreferences.getCardsPinned();
    });
  }

  void _reloadReaderCards() async {
    setState(() {
      pinnedCards = AppPreferences.getCardsPinned();
      defaultReaderCards = _getReaderCard();
      modifiedReaderCards = defaultReaderCards;
    });
  }

  Future<List<ReaderCard>?> _getReaderCard() async {
    var cardsResponse = await Data.check(Data.getReaderCards, null);
    var jsonStorage = jsonDecode(cardsResponse.body) as List;
    List<Storage> storages =
        jsonStorage.map((tagJson) => Storage.fromJson(tagJson)).toList();
    Utils.parseToReaderCards(storages);
    return Future.value(Utils.parseToReaderCards(storages));
  }

  void _setReaderCards(Future<List<ReaderCard>?> newStorageList) {
    setState(() {
      modifiedReaderCards = newStorageList;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget seachField = const SizedBox(height: 0, width: 0);

    if (site != CardPageType.Favoriten) {
      seachField = Row(
        children: [
          Expanded(
            child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
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
                setReaderCards: _setReaderCards,
                defaultCards: defaultReaderCards,
              ).buildBottomSheet(context);
            },
            icon: const Icon(Icons.adjust),
            iconSize: 30,
          )
        ],
      );
    }
    CustomAppBar customAppBar =
        CustomAppBar(title: site.toString().replaceAll("CardPageType.", ""));
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: customAppBar,
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              seachField,
              const SizedBox(height: 10),
              FutureBuilder<List<ReaderCard>?>(
                  future: modifiedReaderCards,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const ConnectionStatusTextfield(
                        text: 'Keine Verbindung zum Server',
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const ConnectionStatusTextfield(
                        text: 'Es wurden keine Karten angelegt',
                      );
                    } else if (site == CardPageType.Favoriten &&
                        (pinnedCards == null || pinnedCards!.isEmpty)) {
                      return ConnectionStatusTextfield(
                          text: 'Keine Favoriten ');
                    } else {
                      final cards = snapshot.data!;
                      switch (site) {
                        case CardPageType.Karten:
                          return CardViewData(
                            customAppBar: customAppBar,
                            readercards: cards,
                            searchstring: searchString,
                            pinnedCards: pinnedCards!,
                            reloadPinned: _reloadPinnedList,
                            reloadCard: _reloadReaderCards,
                            setState: setState,
                            child: CardView(),
                          );
                        case CardPageType.Favoriten:
                          return CardViewData(
                            customAppBar: customAppBar,
                            readercards: cards,
                            searchstring: searchString,
                            pinnedCards: pinnedCards!,
                            reloadPinned: _reloadPinnedList,
                            reloadCard: _reloadReaderCards,
                            setState: setState,
                            child: FavoriteView(),
                          );

                        //users.map((e) => e.cards).toList()
                        case CardPageType.Reservierungen:
                          break;
                      }
                    }
                    return const Text("Error");
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: const Icon(
            Icons.replay,
            color: Colors.white,
          ),
          onPressed: () => {_reloadReaderCards()},
        ));
  }
}
