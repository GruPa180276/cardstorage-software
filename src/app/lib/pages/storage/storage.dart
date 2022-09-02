import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'alter_storage.dart';
import 'add_Storage.dart';
import 'remove_storage.dart';

import 'package:app/config/text_values/tab2_text_values.dart';

// ToDo: Changed the API Calls to the actual API

Tab2TextProvider tab2TextProvider = new Tab2TextProvider();

class Tab2 extends StatefulWidget {
  Tab2({Key? key}) : super(key: key) {}

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Icon(Icons.settings, color: Theme.of(context).focusColor),
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
                              builder: (context) => AddStorage(),
                            ));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FloatingActionButton.extended(
                      label: Text("Remove"),
                      icon: Icon(Icons.remove),
                      foregroundColor: Theme.of(context).focusColor,
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RemoveStorage(),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(children: [ListCardStorages()])),
            )
          ]),
        ));
  }
}

class ListCardStorages extends StatefulWidget {
  const ListCardStorages({Key? key}) : super(key: key);

  @override
  State<ListCardStorages> createState() => _ListCardStoragesState();
}

class _ListCardStoragesState extends State<ListCardStorages> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
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
                return createStorage(context, data, index);
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
          setStateOfCardStorage(data[index].title.toString()),
          setStateOfCardStorageIcon(data[index].title.toString()),
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
              builder: (context) => StorageSettings(data[index].id - 1),
            ));
      },
    );
  }

  Widget setStateOfCardStorage(String storage) {
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

  Widget setStateOfCardStorageIcon(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    IconData storageIcon = Icons.not_started;
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageIcon = Icons.wifi;
    } else if (apiCall == "y") {
      storageIcon = Icons.wifi_off_outlined;
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
