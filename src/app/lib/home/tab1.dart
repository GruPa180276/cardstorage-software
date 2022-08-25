import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../properties/tab1_properties.dart';
import '../stats/tab1_stats.dart';

// ToDo: Changed the API Calls to the actual API

Tab1ColorProvider tab1ColorProvider = new Tab1ColorProvider();
Tab1TextProvider tab1TextProvider = new Tab1TextProvider();
Tab1IconProvider tab1IconProvider = new Tab1IconProvider();

class Tab1 extends StatefulWidget {
  Tab1({Key? key}) : super(key: key) {}

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  String dropDownText = tab1TextProvider.getDropDownText();
  var dropDownValues = tab1TextProvider.getDropDownValues();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: 80,
          decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: tab1ColorProvider.getStorageSelectorBorderColor(),
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: <Widget>[
              DropdownButton(
                value: dropDownText,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 30,
                underline: Container(
                  height: 2,
                  color: tab1ColorProvider.getStorageSelectorDividerColor(),
                ),
                items: dropDownValues.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    alignment: Alignment.center,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropDownText = newValue!;
                  });
                },
              ),
            ],
          )),
      Positioned(
          top: 100,
          left: 0,
          right: 0,
          bottom: 10,
          child: ListCards(cardStorage: dropDownText))
    ]);
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
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (widget.cardStorage == "Select Storage...") {
          return createWelcomePage(context);
        }
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
        return const CircularProgressIndicator();
      },
    );
  }

  Widget createWelcomePage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: tab1ColorProvider.getWelcomePageBorderColor(),
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        Text(tab1TextProvider.getWelcomePageHeadline(),
            style: TextStyle(fontSize: 25)),
        Divider(
          color: tab1ColorProvider.getWelcomePageDividerColor(),
          height: 10,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Expanded(
            child: ListView(
          children: <Widget>[
            Text(tab1TextProvider.getWelcomePageText(),
                style: TextStyle(fontSize: 20))
          ],
        )),
      ]),
    );
  }

  Widget createCard(BuildContext context, List<Data>? data, int index) {
    return InkWell(
      child: Container(
        height: 85,
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: tab1ColorProvider.getCardContainerBorderColor(),
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned(
              left: 100,
              child: Text(data![index].title,
                  style: const TextStyle(fontSize: 20))),
          setStateOfCard(data[index].title.toString()),
          setIconOfCard(data[index].title.toString()),
          Icon(
            tab1IconProvider.getContainerIcon(),
            size: 60,
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
      cardState = Text("Verfügbar", style: const TextStyle(fontSize: 20));
    } else if (apiCall == "y") {
      cardState = Text("Nicht Verfügbar", style: const TextStyle(fontSize: 20));
    }
    return Positioned(left: 140, top: 30, child: cardState);
  }

  Widget setIconOfCard(String card) {
    // ignore: unused_local_variable
    String cardName = card;
    IconData cardIcon = Icons.not_started;
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      cardIcon = tab1IconProvider.getCardIconAvailable();
    } else if (apiCall == "y") {
      cardIcon = tab1IconProvider.getCardIconUnavailable();
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
