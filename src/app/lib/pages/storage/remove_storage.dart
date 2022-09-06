import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/config/values/tab2_text_values.dart';
import 'package:app/domain/values/tab2_storage_values.dart';

// ToDo: The Api needs to be changed in the future

Tab2StorageValuesProvider tab2SSVP = new Tab2StorageValuesProvider();
Tab2RemoveStorageDescriptionProvider tab2RSDP =
    new Tab2RemoveStorageDescriptionProvider();

List<String> values = [];
List<String> id = [];

class RemoveStorage extends StatefulWidget {
  RemoveStorage({Key? key}) : super(key: key);

  @override
  State<RemoveStorage> createState() => _RemoveStorageState();
}

class _RemoveStorageState extends State<RemoveStorage> {
  void setID(String data) {
    setState(() {
      id.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              tab2RSDP.getAppBarTitle(),
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  foregroundColor: Theme.of(context).focusColor,
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  onPressed: () {
                    id = [];
                    setState(() {});
                  },
                  child: Icon(Icons.clear),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                      child: FloatingActionButton.extended(
                    icon: Icon(Icons.search),
                    label: Text("Search"),
                    foregroundColor: Theme.of(context).focusColor,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(this.setID));
                    },
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: FloatingActionButton.extended(
                    icon: Icon(Icons.remove),
                    label: Text("Remove"),
                    foregroundColor: Theme.of(context).focusColor,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      // ToDo: API Call to remove Storage from DB
                    },
                  )),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(children: [
                InputFields2(),
                ShowUsers2(),
              ]),
            ))
          ]),
        ));
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
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      futureData = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Data>>(
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
        return Container(
            child: Column(
          children: [
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).focusColor),
            )
          ],
        ));
      },
    ));
  }

  Widget createStorage(BuildContext context, List<Data>? data, int index) {
    return InkWell(
      child: Container(
        height: 85,
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 0, top: 5, bottom: 5, right: 0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned(
              left: 100,
              child: Text(data![index].title,
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor))),
          setStateOdCardStorage(data[index].title.toString()),
          setCardStorageIcon(data[index].title.toString()),
          Icon(
            Icons.credit_card,
            size: 60,
            color: Theme.of(context).primaryColor,
          )
        ]),
      ),
    );
  }

  Widget setStateOdCardStorage(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    Widget storageState = Text("");
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageState = Text("Online",
          style:
              TextStyle(fontSize: 20, color: Theme.of(context).primaryColor));
    } else if (apiCall == "y") {
      storageState = Text("Offline",
          style:
              TextStyle(fontSize: 20, color: Theme.of(context).primaryColor));
    }
    return Positioned(left: 140, top: 30, child: storageState);
  }

  Widget setCardStorageIcon(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    IconData storageIcon = Icons.not_started;
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageIcon = Icons.wifi;
    } else if (apiCall == "y") {
      storageIcon = Icons.wifi_off;
    }
    return Positioned(
        left: 100,
        top: 30,
        child: Icon(
          storageIcon,
          color: Theme.of(context).primaryColor,
        ));
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
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      futureData = fetchData();
    });
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
        return SizedBox.shrink();
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
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).primaryColor,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).primaryColor,
      ),
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
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(children: [
                Text(
                  result,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ]),
            ),
            onTap: () {
              setState(matchQuery[index]);
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
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(children: [
                Text(
                  result,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ]),
            ),
            onTap: () {
              setState(matchQuery[index]);
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
