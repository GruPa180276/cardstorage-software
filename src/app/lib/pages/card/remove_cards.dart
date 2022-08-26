import 'package:app/values/tab3_card_values.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../values/tab3_card_values.dart';
import '../text/tab3_text_values.dart';
import '../color/tab3_color_values.dart';

// ToDo: The Api needs to be changed in the future

Tab3StorageSettingsValuesProvider tab3SSVP =
    new Tab3StorageSettingsValuesProvider();
Tab3RemoveStorageDescriptionProvider tab3ASDP =
    new Tab3RemoveStorageDescriptionProvider();
Tab3AlterStorageColorProvider tab3ASCP = new Tab3AlterStorageColorProvider();

List<String> values = [];
List<String> id = [];

class RemoveCards extends StatefulWidget {
  RemoveCards({Key? key}) : super(key: key) {}

  @override
  State<RemoveCards> createState() => _RemoveCardsState();
}

class _RemoveCardsState extends State<RemoveCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(tab3ASDP.getAppBarTitle()),
            backgroundColor: tab3ASCP.getAppBarColor(),
            actions: []),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Icon(Icons.refresh),
                ),
              ),
            ),
          ],
        ),
        body: Stack(children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: FloatingActionButton.extended(
                  icon: Icon(Icons.search),
                  label: Text("Search"),
                  backgroundColor: Colors.blueGrey,
                  onPressed: () {
                    showSearch(
                        context: context, delegate: CustomSearchDelegate());
                  },
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FloatingActionButton.extended(
                  icon: Icon(Icons.remove),
                  label: Text("Remove"),
                  backgroundColor: Colors.blueGrey,
                  onPressed: () {
                    // ToDo: API Call to remove Storage from DB
                  },
                )),
              ],
            ),
          ),
          InputFields2(),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            bottom: 22,
            child: ShowUsers2(),
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
        ]));
  }
}

class ShowUsers2 extends StatefulWidget {
  const ShowUsers2({Key? key}) : super(key: key);

  @override
  State<ShowUsers2> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers2> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                for (int i = 0; i < id.length; i++) {
                  if (data![index].title == id.elementAt(i)) {
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

  Widget setStateOdCardStorage(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    Widget storageState = Text("");
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageState = Text("Verfügbar", style: const TextStyle(fontSize: 20));
    } else if (apiCall == "y") {
      storageState =
          Text("Nicht verfügbar", style: const TextStyle(fontSize: 20));
    }
    return Positioned(left: 140, top: 30, child: storageState);
  }

  Widget setCardStorageIcon(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    IconData storageIcon = Icons.not_started;
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageIcon = Icons.check;
    } else if (apiCall == "y") {
      storageIcon = Icons.cancel_rounded;
    }
    return Positioned(left: 100, top: 30, child: Icon(storageIcon));
  }

  Widget createStorage(BuildContext context, List<Data>? data, int index) {
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
              child: Text(data![index].title,
                  style: const TextStyle(fontSize: 20))),
          setStateOdCardStorage(data[index].title.toString()),
          setCardStorageIcon(data[index].title.toString()),
          const Positioned(
              left: 15,
              top: 7,
              child: Icon(
                Icons.credit_card,
                size: 50,
              ))
        ]),
      ),
    );
  }
}

class InputFields2 extends StatefulWidget {
  const InputFields2({Key? key}) : super(key: key);

  @override
  State<InputFields2> createState() => _InputFields2State();
}

class _InputFields2State extends State<InputFields2> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    values = [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          addValues(data!);
          return Container();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void addValues(List<Data> data) {
    values.length = 0;
    for (int i = 0; i < data.length; i++) {
      values.add(data[i].title);
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {
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
              id.add(matchQuery[index]);
            });
      },
    );
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
              id.add(matchQuery[index]);
            });
      },
    );
  }
}

Future<List<Data>> fetchData() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final int userId;
  final int id;
  final String title;

  Data({required this.userId, required this.id, required this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
