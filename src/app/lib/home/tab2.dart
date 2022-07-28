import 'package:flutter/material.dart';
import '../color/color.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/storage_settings.dart';
import '../storage/add_Storage.dart';

// ToDo: Changed the API Calls to the actual API

Tab2ColorProvider tab2CP = new Tab2ColorProvider();

class Tab2 extends StatefulWidget {
  Tab2({Key? key}) : super(key: key) {}

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddStorage(),
                          ));
                    },
                    child: Text('Neuen Automaten hinzufügen'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
              Divider(
                color: Colors.blueGrey,
                height: 20,
                thickness: 2,
                indent: 5,
                endIndent: 5,
              ),
            ],
          ),
        ),
        Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 22,
            child: Stack(children: [ListCardStorages()]))
      ],
    );
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

  Widget setStateOdCardStorage(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    Widget storageState = Text("");
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageState = Text("Online", style: const TextStyle(fontSize: 20));
    } else if (apiCall == "y") {
      storageState = Text("Offline", style: const TextStyle(fontSize: 20));
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
      storageIcon = Icons.wifi_off_outlined;
    }
    return Positioned(left: 100, top: 30, child: Icon(storageIcon));
  }

  Widget createStorage(BuildContext context, List<Data>? data, int index) {
    return InkWell(
      child: Container(
        height: 70,
        margin: const EdgeInsets.all(5.0),
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
                Icons.storage_rounded,
                size: 50,
              ))
        ]),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StorageSettings(data[index].id),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return createStorage(context, data, index);
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
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
