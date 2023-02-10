import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/card/cardInkwell.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/provider/types/storages.dart' as storage;

class CardsView extends StatefulWidget {
  CardsView({Key? key}) : super(key: key);

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  late String selectedStorage = "-";
  List<String> dropDownValues = ["-"];
  List<Storages>? listOfStorages;

  late List<Storages> listOfCards = [];
  List<Storages> persons = [];
  List<Storages> original = [];
  TextEditingController txtQuery = new TextEditingController();

  void test() async {
    await storage.fetchData().then((value) => listOfStorages = value);

    for (int i = 0; i < listOfStorages!.length; i++) {
      dropDownValues.add(listOfStorages![i].name);
    }
  }

  void loadData() async {
    await storage.fetchData().then((value) => listOfCards = value);

    persons = listOfCards;
    original = listOfCards;
    setState(() {});
  }

  void search(String query) {
    if (query.isEmpty) {
      persons = original;
      setState(() {});
      return;
    }

    query = query.toLowerCase();

    List<Storages>? result = listOfStorages;
    for (int i = 0; i < persons.length; i++) {
      List<Cards> tmp = [];
      for (int j = 0; j < persons[i].cards.length; j++) {
        var name = persons[i].cards[j].name.toString().toLowerCase();
        if (name.contains(query)) {
          tmp.add(persons[i].cards[j]);
        }
      }

      result![i].cards = tmp;
    }

    persons = result!;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    test();

    loadData();
  }

  void reload() {
    setState(() {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GenerateReloadButton(this.reload),
      appBar: generateAppBar(context),
      body: Container(
          padding: EdgeInsets.all(5),
          child: Column(children: [
            Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          generateButtonRound(
                              context, "Hinzufügen", Icons.add, "/addCards"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: txtQuery,
                            onChanged: search,
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  txtQuery.text = '';
                                  search(txtQuery.text);
                                },
                              ),
                            ),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor:
                                    Theme.of(context).secondaryHeaderColor,
                                foregroundColor: Theme.of(context).focusColor,
                                minimumSize: Size(0, 60)),
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
                                              child:
                                                  Text(valueItem.toString()));
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
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
                child: Container(
              child: Column(children: <Widget>[
                ListCards(
                  cardStorage: selectedStorage,
                  cards: persons,
                )
              ]),
            )),
          ])),
    );
  }
}

// ignore: must_be_immutable
class ListCards extends StatefulWidget {
  final String cardStorage;
  List<Storages> cards;

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
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.cards.length,
            itemBuilder: (BuildContext context, int index) {
              List<Cards>? data = widget.cards[index].cards;
              if (widget.cards[index].name == widget.cardStorage) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GenerateCard(
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
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GenerateCard(
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
            }));
  }
}
