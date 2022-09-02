import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/config/text_values/tab1_text_values.dart';
import 'tab1_stats.dart';

// ToDo: Changed the API Calls to the actual API

Tab1TextValues tab1TextProvider = new Tab1TextValues();

class Tab1 extends StatefulWidget {
  Tab1({Key? key}) : super(key: key) {}

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  String selectedStorage = "1";
  String dropDownText = tab1TextProvider.getDropDownText();
  var dropDownValues = tab1TextProvider.getDropDownValues();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 28.0),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
        visible: true,
        curve: Curves.bounceInOut,
        children: [
          SpeedDialChild(
            child: Icon(Icons.storage, color: Theme.of(context).focusColor),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            onTap: () => setState(() {
              selectedStorage = "1";
            }),
            label: '1',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).focusColor),
            labelBackgroundColor: Theme.of(context).secondaryHeaderColor,
          ),
          SpeedDialChild(
            child: Icon(Icons.storage, color: Theme.of(context).focusColor),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            onTap: () => setState(() {
              selectedStorage = "2";
            }),
            label: '2',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).focusColor),
            labelBackgroundColor: Theme.of(context).secondaryHeaderColor,
          ),
          SpeedDialChild(
            child: Icon(Icons.storage, color: Theme.of(context).focusColor),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            onTap: () => setState(() {
              selectedStorage = "3";
            }),
            label: '3',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).focusColor),
            labelBackgroundColor: Theme.of(context).secondaryHeaderColor,
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
          Icon(
            Icons.account_box_rounded,
            color: Theme.of(context).focusColor,
          ),
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
          child: Column(
            children: <Widget>[ListCards(cardStorage: selectedStorage)],
          )),
    );
  }
}

class ListCards extends StatefulWidget {
  final String cardStorage;
  const ListCards({Key? key, required this.cardStorage}) : super(key: key);

  @override
  State<ListCards> createState() => _MyAppState();
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
        return Center(
            child: Container(
                child: Column(
          children: [
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).focusColor),
            )
          ],
        )));
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
              color: Theme.of(context).secondaryHeaderColor,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned(
              left: 100,
              child: Text(data![index].title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ))),
          setStateOfCard(data[index].title.toString()),
          setIconOfCard(data[index].title.toString()),
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
              builder: (context) => const CardStats(),
            ));
      },
    );
  }

  Widget setStateOfCard(String card) {
    // ignore: unused_local_variable
    String cardName = card;
    Widget cardState = Text("");
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      cardState = Text("Verfügbar",
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
          ));
    } else if (apiCall == "y") {
      cardState = Text("Nicht Verfügbar",
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
          ));
    }
    return Positioned(left: 140, top: 30, child: cardState);
  }

  Widget setIconOfCard(String card) {
    // ignore: unused_local_variable
    String cardName = card;
    IconData cardIcon = Icons.not_started;
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      cardIcon = Icons.abc;
    } else if (apiCall == "y") {
      cardIcon = Icons.abc;
    }
    return Positioned(
        left: 100,
        top: 30,
        child: Icon(
          cardIcon,
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
