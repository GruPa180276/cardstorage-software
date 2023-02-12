// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:card_master/admin/provider/types/focus.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/provider/types/cards.dart' as card;
import 'package:card_master/admin/provider/types/storages.dart' as storage;
import 'package:card_master/admin/provider/types/storages.dart';

class OtpTimer extends StatefulWidget {
  final String? name;

  const OtpTimer({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 20;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  Cards tmp = Cards(
    name: "",
    storage: "",
    position: 0,
    accessed: 0,
    available: false,
    reader: "",
  );

  void getCard() async {
    await getCardByName(widget.name!).then((value) => tmp = value);
  }

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        getCard();
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Karte anlegen',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Karte wurde angelegt!",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
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
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                        color: Theme.of(context).focusColor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                              ]),
                            ],
                          )),
                    ],
                  ));
        }
        if (tmp.reader != "") {
          timer.cancel();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Karte anlegen',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Karte wurde angelegt!",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
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
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                        color: Theme.of(context).focusColor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                              ]),
                            ],
                          )),
                    ],
                  ));
        }
      });
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer),
        SizedBox(
          width: 5,
        ),
        Text(timerText)
      ],
    );
  }
}

class AddCards extends StatefulWidget {
  const AddCards({Key? key}) : super(key: key);

  @override
  State<AddCards> createState() => _AddCardsState();
}

class _AddCardsState extends State<AddCards> {
  String selectedStorage = "-";
  List<String> dropDownValuesNames = ["-"];
  late List<Storages> listOfStorages = [];
  late List<Cards> s = [];
  late List<FocusS> unfocused = [];

  @override
  void initState() {
    super.initState();
    loadData();
    test();
  }

  void test() async {
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
            "Karte hinzufügen",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          actions: []),
      body: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              GenerateInputFields(
                s: s,
                selectedStorage: selectedStorage,
                dropDownValues: dropDownValuesNames,
                storages: listOfStorages,
              )
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class GenerateInputFields extends StatefulWidget {
  String selectedStorage;
  final List<String> dropDownValues;
  final List<Storages> storages;
  final List<Cards> s;

  GenerateInputFields({
    Key? key,
    required this.selectedStorage,
    required this.dropDownValues,
    required this.s,
    required this.storages,
  }) : super(key: key);

  @override
  State<GenerateInputFields> createState() => _GenerateInputFieldsState();
}

class _GenerateInputFieldsState extends State<GenerateInputFields> {
  late Cards car = new Cards(
    name: "",
    storage: "",
    position: 0,
    accessed: 0,
    available: false,
    reader: "",
  );
  String storageName = "";

  @override
  void initState() {
    super.initState();
  }

  void setName(String value) {
    car.name = value;
  }

  void setStorage(String value) {
    storageName = value;
  }

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: car.name);

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
                    if (widget.s[i].name == value) {
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
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Column(children: [
                  DecoratedBox(
                      decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          border: Border.all(
                            color: Colors.black38,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.57),
                              blurRadius: 5,
                            )
                          ]),
                      child: Center(
                          child: DropdownButton(
                        focusColor: Theme.of(context).focusColor,
                        dropdownColor: Theme.of(context).backgroundColor,
                        iconEnabledColor: Theme.of(context).focusColor,
                        iconDisabledColor: Theme.of(context).focusColor,
                        value: widget.selectedStorage,
                        items: widget.dropDownValues.map((valueItem) {
                          return DropdownMenuItem(
                              value: valueItem,
                              child: Text(
                                valueItem.toString(),
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.selectedStorage = newValue!;
                          });
                          setStorage(newValue!);
                        },
                      )))
                ]),
              ),
              GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 70,
                    child: Column(children: [
                      generateButtonRectangle(
                        context,
                        "Karte hinzufügen",
                        () async {
                          if (_formKey.currentState!.validate()) {
                            Cards newEntry = Cards(
                              name: car.name,
                              storage: storageName,
                              position: car.position,
                              accessed: car.accessed,
                              available: car.available,
                              reader: "",
                            );

                            Future<int> code = card.sendData(newEntry.toJson());

                            if (await code == 200) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        title: Text(
                                          'Karte anlegen',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            OtpTimer(
                                              name: newEntry.name,
                                            ),
                                            Text(
                                              "Bitte Karte scannen",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              height: 70,
                                              child: Column(
                                                children: [
                                                  Column(children: [
                                                    ElevatedButton(
                                                      onPressed: () {},
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
                            if (await code == 400) {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        title: Text(
                                          'Karte anlegen',
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
                                              "Es ist ein Fehler beim anlegen der Karte aufgetreten!",
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
