import 'package:admin_login/pages/widget/reloadbutton.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/provider/types/storages.dart' as storage;
import 'package:admin_login/provider/types/cards.dart';
import 'package:admin_login/pages/widget/cardwithinkwell.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/appbar.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

class CardsView extends StatefulWidget {
  CardsView({Key? key}) : super(key: key);

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  late Future<List<Storages>> futureData;
  late String selectedStorage = "-";
  List<String> dropDownValues = ["-"];
  List<Storages>? listOfStorages;

  @override
  void initState() {
    super.initState();
    futureData = storage.fetchData();
    test();
  }

  void test() async {
    await storage.fetchData().then((value) => listOfStorages = value);

    for (int i = 0; i < listOfStorages!.length; i++) {
      dropDownValues.add(listOfStorages![i].name);
    }
  }

  void reload() {
    setState(() {
      futureData = storage.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GenerateReloadButton(this.reload),
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
                            Text("Filter: " + selectedStorage,
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Filter Storage"),
                              actions: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: DropdownButtonFormField(
                                    value: selectedStorage,
                                    items: dropDownValues.map((valueItem) {
                                      return DropdownMenuItem(
                                          value: valueItem,
                                          child: Text(valueItem.toString()));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedStorage = newValue!;
                                        Navigator.of(ctx).pop();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                  cards: futureData,
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
  Future<List<Storages>> cards;

  ListCards({
    Key? key,
    required this.cardStorage,
    required this.cards,
  }) : super(key: key);

  @override
  State<ListCards> createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  @override
  void initState() {
    super.initState();
    widget.cards = storage.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Storages>>(
        future: widget.cards,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.length; i++) {
              List<Cards>? data = snapshot.data![i].cards;
              if (snapshot.data![i].name == widget.cardStorage) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GenerateCardWithInkWell.withArguments(
                        index: index,
                        data: data,
                        icon: Icons.credit_card,
                        route: "/alterCards",
                        argument: data[index].name,
                        view: 1,
                      );
                    });
              } else if (widget.cardStorage == "-") {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GenerateCardWithInkWell.withArguments(
                        index: index,
                        data: data,
                        icon: Icons.credit_card,
                        route: "/alterCards",
                        argument: data[index].name,
                        view: 1,
                      );
                    });
              } else {
                return SizedBox.shrink();
              }
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Container(
              child: Column(
            children: [generateProgressIndicator(context)],
          ));
        },
      ),
    );
  }
}
