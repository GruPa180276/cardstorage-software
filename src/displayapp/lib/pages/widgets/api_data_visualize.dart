// ignore_for_file: deprecated_member_use
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/domain/enum/readercard_type.dart';
import 'package:rfidapp/pages/widgets/inheritated/cards_inherited.dart';
import 'package:rfidapp/pages/widgets/views/reservate_view.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:rfidapp/pages/widgets/views/card_view.dart';
import 'package:rfidapp/domain/app_preferences.dart';
import 'package:rfidapp/provider/rest/types/storage.dart';
import 'package:rfidapp/pages/widgets/pop_up/bottom_filter.dart';
import 'package:rfidapp/provider/websocket/websocket_callback.dart';

class ApiVisualizer extends StatefulWidget {
  CardPageType site;
  ApiVisualizer({super.key, required this.site});

  @override
  // ignore: no_logic_in_create_state
  State<ApiVisualizer> createState() => _ApiVisualizerState(site: site);
}

class _ApiVisualizerState extends State<ApiVisualizer> {
  _ApiVisualizerState({required this.site});
  Future<Storage?>? _defaultStorage; //is only here to filter
  Future<Storage?>? _modifiedStorage;
  late bool _isDark;
  String _searchString = "";
  CardPageType site;

  @override
  void initState() {
    super.initState();
    WebsocketCallBack.setBuildContext(context);
    _reloadCardList();
    _isDark = AppPreferences.getIsOn();
  }

  void _reloadCardList() {
    setState(() {
      _defaultStorage = _getReaderCards();
      _modifiedStorage = null;
    });
  }

  Future<Storage?> _getReaderCards() async {
    var respone = await Data.check(Data.getStorageData, null);
    return Storage.fromJson(jsonDecode(respone.body));
  }

  void _setListType(Future<Storage?> cardsNew) {
    setState(() {
      _modifiedStorage = cardsNew;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget seachField = const SizedBox(height: 5, width: 0);

    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 56,
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Stack(
              children: [
                Text(site.toString().replaceAll("CardPageType.", ""),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                Container(
                    alignment: Alignment.bottomRight,
                    child: buildChangeThemeMode(context)),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: IconButton(
                      onPressed: () {
                        BottomSheetPop(
                                onPressStorage: _setListType,
                                defaultStorage: _defaultStorage!,
                                cardPageType: site)
                            .buildBottomSheet(context);
                      },
                      icon: const Icon(Icons.adjust),
                      color: Theme.of(context).primaryColor),
                )
              ],
            )),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              seachField,
              const SizedBox(height: 10),
              FutureBuilder<Storage?>(
                future: _modifiedStorage ?? _defaultStorage,
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
                            'No Data received!',
                            style: TextStyle(
                                color: Theme.of(context).dividerColor,
                                fontSize: 20),
                          ),
                        );
                      } else {
                        final users = snapshot.data!;
                        switch (site) {
                          case CardPageType.Karten:
                            return CardViewData(
                                searchstring: _searchString,
                                storage: users,
                                setState: setState,
                                child: CardView());
                          case CardPageType.Reservierungen:
                            return CardViewData(
                                searchstring: _searchString,
                                storage: users,
                                setState: setState,
                                child: ReservateView());
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
          onPressed: () => {_reloadCardList()},
        ));
  }

  Widget buildChangeThemeMode(BuildContext context) {
    return Switch(
        activeColor: Theme.of(context).secondaryHeaderColor,
        value: _isDark,
        onChanged: (value) async {
          await AppPreferences.setIsOn(value);
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          _isDark = value;
          setState(() {
            provider.toggleTheme(value);
          });
        });
  }
}
