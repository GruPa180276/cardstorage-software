import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'add_user.dart';
import 'alter_user.dart';
import 'remove_users.dart';

import 'package:app/config/text_values/tab4_text_values.dart';
import 'package:app/config/color_values/tab4_color_values.dart';

Tab4DescrpitionProvider tab4DP = new Tab4DescrpitionProvider();
Tab4ColorProvider tab4CP = new Tab4ColorProvider();

List<String> values = [];
List<String> id = [];

class Tab4 extends StatefulWidget {
  const Tab4({Key? key}) : super(key: key);

  @override
  State<Tab4> createState() => _Tab4State();
}

class _Tab4State extends State<Tab4> {
  void setID(String data) {
    setState(() {
      id.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Icon(
                    Icons.clear,
                  ),
                ),
              ),
            ),
          ],
        ),
        appBar: AppBar(
          leading: Icon(
            Icons.credit_card,
            size: 30,
            color: Theme.of(context).focusColor,
          ),
          toolbarHeight: 70,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text('Admin Login',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).focusColor)),
          actions: [
            Icon(Icons.account_box_rounded,
                color: Theme.of(context).focusColor),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.settings,
              color: Theme.of(context).focusColor,
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.logout,
              color: Theme.of(context).focusColor,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FloatingActionButton.extended(
                      label: Text("Add"),
                      icon: Icon(Icons.add),
                      foregroundColor: Theme.of(context).focusColor,
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddUser(),
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
                      foregroundColor: Theme.of(context).focusColor,
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RemoveUsers(),
                            ));
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
                    foregroundColor: Theme.of(context).focusColor,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(this.setID));
                    },
                  )),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(children: [
                InputFields(),
                ShowUsers(),
              ]),
            ))
          ]),
        ));
  }
}

class ShowUsers extends StatefulWidget {
  const ShowUsers({Key? key}) : super(key: key);

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserSettings(data[index].title),
            ));
      },
    );
  }

  Widget setStateOdCardStorage(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    Widget storageState = Text("");
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageState = Text("Verfügbar",
          style:
              TextStyle(fontSize: 20, color: Theme.of(context).primaryColor));
    } else if (apiCall == "y") {
      storageState = Text("Nicht verfügbar",
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
      storageIcon = Icons.event_available;
    } else if (apiCall == "y") {
      storageIcon = Icons.event_busy;
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

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    reloadCardList();
    values = [];
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
                Text(result,
                    style: TextStyle(color: Theme.of(context).primaryColor))
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
