import 'package:app/stats/tab1_stats.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../color/color.dart';
import '../description/description.dart';

Tab1ColorProvider tab1CP = new Tab1ColorProvider();
Tab1DescrpitionProvider tab1DP = new Tab1DescrpitionProvider();

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  String dropDownText = tab1DP.getDropDownText();
  var dropDownValues = tab1DP.getDropDownValues();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          padding: const EdgeInsets.all(7),
          margin: const EdgeInsets.all(7),
          height: 80,
          decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: tab1CP.getStorageSelectorBorderColor(),
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
                  color: tab1CP.getStorageSelectorDividerColor(),
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
          bottom: 22,
          child: Stack(children: [ListCards(cardStorage: dropDownText)]))
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

  Widget setSateOfCards(String card) {
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

  Widget setIconOfCards(String card) {
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

  Widget createCard(BuildContext context, List<Data>? data, int index) {
    return InkWell(
      child: Container(
        height: 70,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: tab1CP.getCardContainerBorderColor(),
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned(
              left: 100,
              child: Text(data![index].title,
                  style: const TextStyle(fontSize: 20))),
          setSateOfCards(data[index].title.toString()),
          setIconOfCards(data[index].title.toString()),
          const Positioned(
              left: 15,
              top: 7,
              child: Icon(
                Icons.credit_card,
                size: 50,
              ))
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

  Widget welcomePage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: tab1CP.getWelcomePageBorderColor(),
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        Text(tab1DP.getWelcomePageHeadline(), style: TextStyle(fontSize: 25)),
        Divider(
          color: tab1CP.getWelcomePageDividerColor(),
          height: 10,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Expanded(
            child: ListView(
          children: <Widget>[
            Text(tab1DP.getWelcomePageText(), style: TextStyle(fontSize: 20))
          ],
        )),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (widget.cardStorage == "Automat auswählen...") {
          return welcomePage(context);
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
