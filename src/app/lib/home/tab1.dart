import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Tab1 extends StatelessWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: const [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Text(
              "Karten",
              style: TextStyle(height: 0, fontSize: 30, color: Colors.grey),
              textAlign: TextAlign.center,
            )),
        Divider(
          color: Colors.grey,
          height: 0,
          thickness: 1.5,
          indent: 10,
          endIndent: 10,
        ),
        ListCards()
      ],
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
                      // Make rounded corners
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(data![index].title),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
