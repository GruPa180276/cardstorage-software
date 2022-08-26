import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:app/pages/right/add_rights.dart';
import 'package:app/pages/right/alter_rights.dart';

import 'package:app/config/text_values/tab5_text_values.dart';
import 'package:app/config/color_values/tab5_color_values.dart';

import 'package:app/provider/types/card.dart';
import 'package:app/provider/API/data_API.dart';

Tab5ColorProvider tab5CP = new Tab5ColorProvider();
Tab5DescrpitionProvider tab5DP = new Tab5DescrpitionProvider();

List<String> values = [];
List<String> id = [];

class Tab5 extends StatefulWidget {
  Tab5({Key? key}) : super(key: key) {}

  @override
  State<Tab5> createState() => _Tab5State();
}

class _Tab5State extends State<Tab5> {
  void setID(String data) {
    setState(() {
      id.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  label: Text("Add"),
                  icon: Icon(Icons.add),
                  backgroundColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRights(),
                        ));
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.remove),
                  label: Text("Remove"),
                  backgroundColor: Colors.blueGrey,
                  onPressed: () {
                    print("object");
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: FloatingActionButton.extended(
                icon: Icon(Icons.search),
                label: Text("Search"),
                backgroundColor: Colors.blueGrey,
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(this.setID));
                },
              )),
            ],
          ),
        ),
        InputFields(),
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          bottom: 22,
          child: ShowCards(),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: Text("Clear"),
              icon: Icon(Icons.clear),
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                id = [];
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ShowCards extends StatefulWidget {
  const ShowCards({Key? key}) : super(key: key);

  @override
  State<ShowCards> createState() => _ShowCardsState();
}

class _ShowCardsState extends State<ShowCards> {
  Future<List<Cards>>? futureData;

  @override
  void initState() {
    super.initState();
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      futureData = Data.getData("card").then((value) =>
          jsonDecode(value.body).map<Cards>(Cards.fromJson).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cards>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cards>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                for (int i = 0; i < id.length; i++) {
                  if (data![index].name == id.elementAt(i)) {
                    return createStorage(context, data, index);
                  }
                }
                return SizedBox.shrink();
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget setStateOdCardStorage(bool? state) {
    Widget storageState = Text("");

    if (state == true) {
      storageState = Text("Verfügbar", style: const TextStyle(fontSize: 20));
    } else if (state == false) {
      storageState =
          Text("Nicht verfügbar", style: const TextStyle(fontSize: 20));
    }
    return Positioned(left: 140, top: 30, child: storageState);
  }

  Widget setCardStorageIcon(bool? state) {
    IconData storageIcon = Icons.not_started;

    if (state == true) {
      storageIcon = Icons.event_available;
    } else if (state == false) {
      storageIcon = Icons.event_busy;
    }
    return Positioned(left: 100, top: 30, child: Icon(storageIcon));
  }

  Widget createStorage(BuildContext context, List<Cards>? data, int index) {
    return InkWell(
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Colors.blueGrey,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned(
              left: 100,
              child: Text(data![index].name.toString(),
                  style: const TextStyle(fontSize: 20))),
          setStateOdCardStorage(data[index].isAvailable),
          setCardStorageIcon(data[index].isAvailable),
          const Positioned(
              left: 15,
              top: 7,
              child: Icon(
                Icons.account_box_outlined,
                size: 50,
              ))
        ]),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RightsSettings(data[index].name.toString(), values),
            ));
      },
    );
  }
}

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  late Future<List<Cards>> futureData;

  @override
  void initState() {
    super.initState();
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      futureData = Data.getData("card").then((value) =>
          jsonDecode(value.body).map<Cards>(Cards.fromJson).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cards>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cards>? data = snapshot.data;
          addValues(data!);
          return Container();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void addValues(List<Cards> data) {
    values.length = 0;
    for (int i = 0; i < data.length; i++) {
      values.add(data[i].name.toString());
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {
  late Function setState;

  CustomSearchDelegate(Function state) {
    setState = state;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in values) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return InkWell(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: Colors.blueGrey,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(children: [Text(result)]),
              ),
              onTap: () {
                setState(matchQuery[index]);
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in values) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.blueGrey,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(children: [Text(result)]),
            ),
            onTap: () {
              setState(matchQuery[index]);
            });
      },
    );
  }
}
