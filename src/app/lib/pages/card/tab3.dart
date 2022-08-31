import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'add_cards.dart';
import 'alter_cards.dart';
import 'remove_cards.dart';

import 'package:app/config/text_values/tab3_text_values.dart';
import 'package:app/config/color_values/tab3_color_values.dart';

// ToDo: Changed the API Calls to the actual API

Tab3ColorProvider tab3CP = new Tab3ColorProvider();
Tab3DescrpitionProvider tab3DP = new Tab3DescrpitionProvider();

class Tab3 extends StatefulWidget {
  Tab3({Key? key}) : super(key: key) {}

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  String selectedStorage = "1";
  String dropDownText = tab3DP.getDropDownText();
  var dropDownValues = tab3DP.getDropDownValues();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 28.0),
          backgroundColor: Colors.blueGrey,
          visible: true,
          curve: Curves.bounceInOut,
          children: [
            SpeedDialChild(
              child: Icon(Icons.storage, color: Colors.white),
              backgroundColor: Colors.blueGrey,
              onTap: () => setState(() {
                selectedStorage = "1";
              }),
              label: '1',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              labelBackgroundColor: Colors.black,
            ),
            SpeedDialChild(
              child: Icon(Icons.storage, color: Colors.white),
              backgroundColor: Colors.blueGrey,
              onTap: () => setState(() {
                selectedStorage = "2";
              }),
              label: '2',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              labelBackgroundColor: Colors.black,
            ),
            SpeedDialChild(
              child: Icon(Icons.storage, color: Colors.white),
              backgroundColor: Colors.blueGrey,
              onTap: () => setState(() {
                selectedStorage = "3";
              }),
              label: '3',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              labelBackgroundColor: Colors.black,
            ),
          ],
        ),
        appBar: AppBar(
          leading: Icon(
            Icons.credit_card,
            size: 30,
          ),
          toolbarHeight: 70,
          backgroundColor: Colors.blueGrey,
          title: Text('Admin Login',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          actions: [
            Icon(Icons.account_box_rounded),
            SizedBox(
              width: 20,
            ),
            Icon(Icons.settings),
            SizedBox(
              width: 20,
            ),
            Icon(Icons.logout),
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
                      backgroundColor: Colors.blueGrey,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCards(),
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
                      backgroundColor: Colors.blueGrey,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RemoveCards(),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                  children: <Widget>[ListCards(cardStorage: selectedStorage)]),
            ))
          ]),
        ));
  }
}

class ListCards extends StatefulWidget {
  final String cardStorage;
  ListCards({Key? key, required this.cardStorage}) : super(key: key);

  @override
  State<ListCards> createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
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
                if (widget.cardStorage == data![index].userId.toString()) {
                  return createCard(context, data, index);
                } else if (widget.cardStorage == "All") {
                  return createCard(context, data, index);
                } else {
                  return const SizedBox.shrink();
                }
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
            child: Column(
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.blueGrey,
              valueColor: AlwaysStoppedAnimation(Colors.green),
            )
          ],
        ));
      },
    ));
  }

  Widget createCard(BuildContext context, List<Data>? data, int index) {
    return InkWell(
      child: Container(
        height: 85,
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 0, top: 5, bottom: 5, right: 0),
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
          setStateOfCardStorage(data[index].title.toString()),
          setCardStorageIcon(data[index].title.toString()),
          Icon(
            Icons.credit_card,
            size: 60,
          )
        ]),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardSettings(data[index].id - 1),
            ));
      },
    );
  }

  Widget setStateOfCardStorage(String card) {
    // ignore: unused_local_variable
    String cardName = card;
    Widget cardState = Text("");
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      cardState = Text("Verfügbar", style: const TextStyle(fontSize: 20));
    } else if (apiCall == "y") {
      cardState = Text("Nicht Verfügbar", style: const TextStyle(fontSize: 20));
    }
    return Positioned(left: 140, top: 30, child: cardState);
  }

  Widget setCardStorageIcon(String card) {
    // ignore: unused_local_variable
    String cardName = card;
    IconData cardIcon = Icons.not_started;
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      cardIcon = Icons.check;
    } else if (apiCall == "y") {
      cardIcon = Icons.cancel_rounded;
    }
    return Positioned(left: 100, top: 30, child: Icon(cardIcon));
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
