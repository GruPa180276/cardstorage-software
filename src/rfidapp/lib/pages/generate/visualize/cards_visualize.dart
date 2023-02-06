// ignore_for_file: deprecated_member_use
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rfidapp/domain/authentication/authentication.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/enums/cardpage_type.dart';
import 'package:rfidapp/pages/generate/views/favorite_view.dart';
import 'package:rfidapp/pages/generate/pop_up/bottom_filter.dart';
import 'package:rfidapp/pages/login/login_user_page.dart';
import 'package:rfidapp/provider/connection/api/data.dart';
import 'package:rfidapp/provider/connection/api/uitls.dart';
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
  late String _email;
  Set<String>? pinnedCards;

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  CardPageTypes site;

  @override
  void initState() {
    super.initState();
    _reloadReaderCards();
    _reloadPinnedList();
    _checkUserRegistered();
  }

  void _checkUserRegistered() async {
    var isRegistered;
    var data = await UserSecureStorage.getUserValues();
    var response =
        await Data.check(Data.checkUserRegistered, {"email": data["Email"]!});
    if (response.statusCode != 200 ||
        jsonDecode(response.body)["email"].toString().isEmpty) {
      isRegistered = false;
    } else {
      isRegistered = true;
    }

    if (!isRegistered) {
      await AadAuthentication.getEnv();
      AadAuthentication.oauth!.logout();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginUserScreen()));
    }
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
                  setReaderCards: _setReaderCards,
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
                  if (modifiedReaderCards == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

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
                              reloadPinned: _reloadPinnedList,
                              reloadCard: _reloadReaderCards,
                              setState: setState,
                            );
                          case CardPageTypes.Favoriten:
                            return FavoriteView(
                              setState: setState,
                              cards: cards,
                              context: context,
                              pinnedCards: pinnedCards!,
                              reloadPinned: _reloadPinnedList,
                              searchstring: searchString,
                              reloadCard: _reloadReaderCards,
                            );

                          //users.map((e) => e.cards).toList()
                          case CardPageTypes.Reservierungen:
                            break;
                        }
                      }
                      return const Text("Error");
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
          onPressed: () => {_reloadReaderCards()},
        ));
  }
}


  //@TODO and voidCallback


