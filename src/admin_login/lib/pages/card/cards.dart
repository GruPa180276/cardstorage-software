import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/widget/cardwithinkwell.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/appbar.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: Changed the API Calls to the actual API

class CardsView extends StatefulWidget {
  CardsView({Key? key}) : super(key: key);

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  String selectedStorage = "78";
  List<String> dropDownValues = ["78", "79"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generateAppBar(context),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
              child: Row(
                children: [
                  generateButtonRound(
                      context, "Hinzufügen", Icons.add, "/addCards"),
                  SizedBox(
                    width: 10,
                  ),
                  generateButtonRound(
                      context, "Entfernen", Icons.remove, "/removeCards")
                ],
              ),
            ),
            Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    child: Text('Show Modal Bottom Sheet'),
                    onPressed: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return Container(
                            child: Column(children: [
                              DropdownButton(
                                value: selectedStorage,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: dropDownValues.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStorage = newValue!;
                                  });
                                },
                              ),
                            ]),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                  children: <Widget>[ListCards(cardStorage: selectedStorage)]),
            )),
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
                  return GenerateCardWithInkWell.withArguments(
                    index: index,
                    data: data,
                    icon: Icons.credit_card,
                    route: "/alterCards",
                    argument: data[index].id - 1,
                    view: 1,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
            child: Column(
          children: [generateProgressIndicator(context)],
        ));
      },
    ));
  }
}
