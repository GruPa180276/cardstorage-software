import 'package:admin_login/provider/types/focus.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/provider/types/cards.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/provider/types/cards.dart' as card;
import 'package:admin_login/provider/types/storages.dart' as storage;
import 'package:admin_login/provider/types/storages.dart';

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
      if (!unfocused.contains(listOfStorages[i].name)) {
        dropDownValuesNames.add(listOfStorages[i].name);
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
                            Cards newEntry = new Cards(
                                name: car.name,
                                storage: storageName,
                                position: car.position,
                                accessed: car.accessed,
                                available: car.available);

                            Future<int> code = card.sendData(newEntry.toJson());

                            if (await code == 200) {
                              Navigator.of(context).pop();
                            }
                            if (await code == 400) {
                              deleteStorage(car.name);
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
