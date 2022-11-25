import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/cards.dart';
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
  String selectedStorage = "-";
  //TODO
  List<dynamic> dropDownValues = ["-", "1117", "1118"];

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
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Builder(
                  builder: (context) {
                    return Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          foregroundColor: Theme.of(context).focusColor,
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Icon(
                              Icons.filter_list,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Filter", style: TextStyle(fontSize: 20)),
                          ],
                        ),
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
                                height: 300,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                child: Column(children: [
                                  const Text(
                                    'Filter',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          child: Text(
                                        'Storage',
                                        style: TextStyle(fontSize: 17),
                                      )),
                                      DropdownButton(
                                        value: selectedStorage,
                                        items: dropDownValues.map((valueItem) {
                                          return DropdownMenuItem(
                                              value: valueItem,
                                              child:
                                                  Text(valueItem.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            if (newValue != '') {
                                              selectedStorage =
                                                  newValue as String;
                                            } else {
                                              selectedStorage =
                                                  newValue as dynamic;
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ]),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                )),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(children: <Widget>[
                ListCards(
                  cardStorage: selectedStorage,
                )
              ]),
            )),
          ]),
        ));
  }
}

// ignore: must_be_immutable
class ListCards extends StatefulWidget {
  final String cardStorage;
  dynamic available;
  ListCards({Key? key, required this.cardStorage}) : super(key: key);

  @override
  State<ListCards> createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  late Future<List<Cards>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Cards>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cards>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                // ToDo: Add bool check
                if (widget.cardStorage == data![index].storageId.toString()) {
                  return GenerateCardWithInkWell.withArguments(
                    index: index,
                    data: data,
                    icon: Icons.credit_card,
                    route: "/alterCards",
                    argument: data[index].id - 1,
                    view: 1,
                  );
                } else if (widget.cardStorage == "-") {
                  return GenerateCardWithInkWell.withoutArguments(
                    index: index,
                    data: data,
                    icon: Icons.credit_card,
                    route: "/alterCards",
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
