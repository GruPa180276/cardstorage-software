// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:rfidapp/pages/generate/views/card_view.dart';
import 'package:rfidapp/domain/app_preferences.dart';
import 'package:rfidapp/provider/types/storage.dart';
import 'package:rfidapp/pages/generate/widget/bottomSheet.dart';
class ApiVisualizer extends StatefulWidget {
  String site;
  ApiVisualizer({super.key, required this.site});

  @override
  State<ApiVisualizer> createState() => _ApiVisualizerState(site: site);
  
}

class _ApiVisualizerState extends State<ApiVisualizer> {
  _ApiVisualizerState({required this.site});
  Future<Storage?>? _cards;
  late bool _isDark;

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  String site;

  @override
  void initState() {
    super.initState();
    reloadCardList();
    _isDark = AppPreferences.getIsOn();
  }



  void reloadCardList() {
    setState(() {
      _cards = Data.getStorageData();
    });
  }

  void setListType(Future<Storage?> cardsNew) {
    setState(() {
      _cards = cardsNew as Future<Storage?>?;
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
                  listOfTypes: _cards!,
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
              FutureBuilder<Storage?>(
                future: _cards,
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
                            return cardsView(users, context, 'reservation', searchString);
                          case "Karten":
                            return cardsView(users, context, 'cards', searchString);
                      
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


