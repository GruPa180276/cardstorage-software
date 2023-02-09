import 'package:admin_login/provider/types/user.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/provider/types/storages.dart';

class AddStorage extends StatefulWidget {
  const AddStorage({Key? key}) : super(key: key);

  @override
  State<AddStorage> createState() => _AddStorageState();
}

class _AddStorageState extends State<AddStorage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Storage hinzufügen",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          actions: []),
      body: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [InputFields()],
          )),
    );
  }
}

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  late Storages stor = new Storages(
    name: "",
    location: "",
    numberOfCards: 0,
    cards: [],
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void setName(String value) {
    stor.name = value;
  }

  void setNumberOfCards(String value) {
    stor.numberOfCards = int.parse(value);
  }

  void setLocation(String value) {
    stor.location = value;
  }

  late List<Storages> s;

  void loadData() async {
    await fetchData().then((value) => s = value);
  }

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();
    final _locationController = TextEditingController();
    final _numCardsController = TextEditingController();

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
                for (int i = 0; i < s.length; i++) {
                  if (s[i].name == value) {
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
            GenerateListTile(
              labelText: "Standort",
              hintText: "",
              icon: Icons.location_city,
              regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
              function: this.setLocation,
              controller: _locationController,
              fun: (value) {
                if (value!.isEmpty) {
                  return 'Bitte Location eingeben!';
                }
                return null;
              },
            ),
            GenerateListTile(
              labelText: "Anzahl an Karten",
              hintText: "",
              icon: Icons.format_list_numbered,
              regExp: r'([0-9])',
              function: this.setNumberOfCards,
              controller: _numCardsController,
              fun: (value) {
                if (value!.isEmpty) {
                  return 'Bitte Anzahl eingeben!';
                }
                return null;
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
                      "Storage hinzufügen",
                      () async {
                        if (_formKey.currentState!.validate()) {
                          Storages newEntry = new Storages(
                              name: stor.name,
                              location: stor.location,
                              numberOfCards: stor.numberOfCards,
                              cards: []);
                          Future<int> code = sendData(newEntry.toJson());

                          Users newUser = new Users(
                            email: newEntry.name.toLowerCase() + "@default.com",
                            storage: stor.name,
                            privileged: false,
                          );

                          if (await code == 200) {
                            code = addUser(newUser.toJson());
                            if (await code == 200) {
                              Navigator.of(context).pop();
                            }
                            if (await code == 400) {
                              code = deleteUser(
                                  stor.name.toLowerCase() + "@default.com");
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        title: Text(
                                          'Storage anlegen',
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
                                              "Es ist ein Fehler beim anlegen des Storages aufgetreten!",
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
                          if (await code == 400) {
                            deleteStorage(stor.name);

                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      title: Text(
                                        'Storage anlegen',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      content: new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Es ist ein Fehler beim anlegen des Storages aufgetreten!",
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
                                                          color:
                                                              Theme.of(context)
                                                                  .focusColor),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Theme.of(
                                                              context)
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
      ),
    );
  }
}
