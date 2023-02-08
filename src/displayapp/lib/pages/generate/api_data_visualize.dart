// ignore_for_file: deprecated_member_use
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/domain/enum/readercard_type.dart';
import 'package:rfidapp/pages/generate/views/reservate_view.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:rfidapp/pages/generate/views/card_view.dart';
import 'package:rfidapp/domain/app_preferences.dart';
import 'package:rfidapp/provider/rest/types/storage.dart';
import 'package:rfidapp/pages/generate/widget/bottom_filter.dart';
import 'package:rfidapp/provider/websocket/websocket_callback.dart';

class ApiVisualizer extends StatefulWidget {
  CardPageType site;
  ApiVisualizer({super.key, required this.site});

  @override
  State<ApiVisualizer> createState() => _ApiVisualizerState(site: site);
}

class _ApiVisualizerState extends State<ApiVisualizer> {
  _ApiVisualizerState({required this.site});
  Future<Storage?>? _defaultStorage; //is only here to filter
  Future<Storage?>? _modifiedStorage;
  late bool _isDark;
  String _searchString = "";
  TextEditingController _searchController = TextEditingController();
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
      _modifiedStorage = _defaultStorage;
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
            toolbarHeight: 31,
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
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
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
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              seachField,
              const SizedBox(height: 10),
              FutureBuilder<Storage?>(
                future: _modifiedStorage,
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
                            return CardView(
                                setState: setState,
                                context: context,
                                searchstring: _searchString,
                                storage: users);
                          case CardPageType.Reservierungen:
                            return ReservateView(
                                context: context,
                                searchstring: _searchString,
                                storage: users);
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





  //@TODO and voidCallback


