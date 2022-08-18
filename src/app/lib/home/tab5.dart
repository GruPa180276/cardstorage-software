import 'package:app/rights/add_rights.dart';
import 'package:app/rights/alter_rights.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../color/tab5_color_values.dart';
import '../text/tab5_text_values.dart';

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
                      context: context, delegate: CustomSearchDelegate());
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
          child: ShowUsers(),
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
      storageIcon = Icons.event_available;
    } else if (apiCall == "y") {
      storageIcon = Icons.event_busy;
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
                Icons.account_box_outlined,
                size: 50,
              ))
        ]),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RightsSettings(data[index].title, values),
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
