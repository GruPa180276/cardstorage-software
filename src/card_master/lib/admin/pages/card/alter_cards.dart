// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:card_master/admin/provider/types/focus.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/provider/types/cards.dart' as card;
import 'package:card_master/admin/provider/types/storages.dart' as storage;

class CardSettings extends StatefulWidget {
  final String cardName;
  CardSettings({
    Key? key,
    required this.cardName,
  }) : super(key: key) {}

  @override
  State<CardSettings> createState() => _CardSettingsState();
}

class _CardSettingsState extends State<CardSettings> {
  String selectedStorage = "-";
  List<String> dropDownValuesNames = ["-"];
  late List<Storages> listOfStorages = [];
  late List<Cards> s = [];
  late List<FocusS> unfocused = [];

  late Cards car = new Cards(
    name: "",
    storage: "",
    position: 0,
    accessed: 0,
    available: false,
    reader: "",
  );

  @override
  void initState() {
    super.initState();
    loadData();
    test();
  }

  void test() async {
    await card.fetchData().then((value) => s = value);
    await storage.fetchData().then((value) => listOfStorages = value);
    await getAllUnfocusedStorages().then((value) => unfocused = value);

    for (int i = 0; i < listOfStorages.length; i++) {
      dropDownValuesNames.add(listOfStorages[i].name);
    }

    for (int i = 0; i < dropDownValuesNames.length; i++) {
      for (int j = 0; j < unfocused.length; j++) {
        if (dropDownValuesNames[i] == unfocused[j].name) {
          dropDownValuesNames.removeAt(i);
          setState(() {});
        }
      }
    }

    for (int i = 0; i < s.length; i++) {
      if (s[i].name == widget.cardName) {
        car = s[i];
      }
    }

    setState(() {});
  }

  void loadData() async {
    await card.fetchData().then((value) => s = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Karte bearbeiten",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
          child: Column(children: [
            Expanded(
              child: Container(
                  child: Column(children: [
                GetDataFromAPI(
                  s: s,
                  selectedStorage: selectedStorage,
                  dropDownValues: dropDownValuesNames,
                  storages: listOfStorages,
                  cardName: widget.cardName,
                  car: car,
                )
              ])),
            )
          ]),
        ));
  }
}

// ignore: must_be_immutable
class GetDataFromAPI extends StatefulWidget {
  String selectedStorage;
  final List<String> dropDownValues;
  final List<Storages> storages;
  final List<Cards> s;
  final String cardName;
  final Cards car;

  GetDataFromAPI({
    Key? key,
    required this.selectedStorage,
    required this.dropDownValues,
    required this.s,
    required this.storages,
    required this.cardName,
    required this.car,
  }) : super(key: key);

  @override
  State<GetDataFromAPI> createState() => _GetDataFromAPIState();
}

class _GetDataFromAPIState extends State<GetDataFromAPI> {
  @override
  void initState() {
    super.initState();
  }

  void setName(String value) {
    widget.car.name = value;
  }

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: widget.cardName);

    final _formKey = GlobalKey<FormState>();

    return Form(
        key: _formKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GenerateListTile(
                labelText: "Name",
                hintText: "",
                icon: Icons.storage,
                regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
                function: this.setName,
                controller: _nameController,
                fun: (value) {
                  for (int i = 0; i < widget.s.length; i++) {
                    if (widget.s[i].name == widget.cardName) {
                      return null;
                    } else if (value!.isEmpty) {
                      return 'Bitte Name eingeben!';
                    } else if (widget.s[i].name == value) {
                      return 'Exsistiert bereits!';
                    }
                  }
                  if (value!.isEmpty) {
                    return 'Bitte Name eingeben!';
                  } else {
                    return null;
                  }
                },
              ),
              GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 70,
                    child: Column(children: [
                      generateButtonRectangle(
                        context,
                        "Karte bearbeiten",
                        () async {
                          if (_formKey.currentState!.validate()) {
                            Cards updateEntry = new Cards(
                              name: widget.car.name,
                              storage: widget.car.storage,
                              position: widget.car.position,
                              accessed: widget.car.accessed,
                              available: widget.car.available,
                              reader: "",
                            );

                            Future<int> code = card.updateData(
                                widget.car.name, updateEntry.toJson());

                            if (await code == 200) {
                              Navigator.of(context).pop();
                            }
                            if (await code == 400) {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        title: Text(
                                          'Karte löschen',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        content: new Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Es ist ein Fehler beim löschen der Karte aufgetreten!",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              height: 70,
                                              child: Column(
                                                children: [
                                                  Column(children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Ok",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .focusColor),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: Theme
                                                                .of(context)
                                                            .secondaryHeaderColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                                ],
                                              )),
                                        ],
                                      ));
                            }
                          }
                        },
                      ),
                    ]),
                  )),
            ],
          ),
        ));
  }
}
