import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  _Tab1 createState() => _Tab1();
}

class _Tab1 extends State<Tab1> {
  String dropdownvalue = 'Automat auswählen...';

  // List of items in our dropdown menu
  var items = [
    'Automat auswählen...',
    'All',
    'Cardstorage 1',
    'Cardstorage 2',
    'Cardstorage 3'
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          padding: const EdgeInsets.all(7),
          margin: const EdgeInsets.all(7),
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 3,
                color: Colors.green,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: <Widget>[
              DropdownButton(
                value: dropdownvalue,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
            ],
          )),
      Positioned(
          top: 100,
          left: 0,
          right: 0,
          bottom: 22,
          child: Stack(children: [ListCards()]))
    ]);
  }
}

class ListCards extends StatefulWidget {
  const ListCards({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ListCards> {
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
                return Container(
                  height: 70,
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 3,
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(data![index].title),
                  ),
                );
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
