import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/provider/types/storages.dart';

class StorageSettings extends StatefulWidget {
  final String storage;

  StorageSettings({
    Key? key,
    required this.storage,
  }) : super(key: key) {}

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  late List<Storages> s = [];
  late Storages stor = new Storages(
    name: "",
    location: "",
    numberOfCards: 0,
    cards: [],
  );

  @override
  void initState() {
    super.initState();
    test();
  }

  void test() async {
    // await fetchStorages().then((value) => s = value);

    for (int i = 0; i < s.length; i++) {
      if (s[i].name == widget.storage) {
        stor = s[i];
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Storage bearbeiten",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(children: [
                    GetDataFromAPI(
                      storageName: widget.storage,
                      s: s,
                      stor: stor,
                    )
                  ])),
            )
          ]),
        ));
  }
}

class GetDataFromAPI extends StatefulWidget {
  final String storageName;
  final Storages stor;
  final List<Storages> s;

  const GetDataFromAPI({
    Key? key,
    required this.storageName,
    required this.s,
    required this.stor,
  }) : super(key: key);

  State<GetDataFromAPI> createState() => _GetDataFromAPIState();
}

class _GetDataFromAPIState extends State<GetDataFromAPI> {
  @override
  void initState() {
    super.initState();
  }

  void setName(String value) {
    widget.stor.name = value;
  }

  void setNumberOfCards(String value) {
    widget.stor.numberOfCards = int.parse(value);
  }

  void setLocation(String value) {
    widget.stor.location = value;
  }

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: widget.stor.name);
    final _locationController =
        TextEditingController(text: widget.stor.location);
    final _numCardsController =
        TextEditingController(text: widget.stor.numberOfCards.toString());

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
                  if (widget.s[i].name == widget.storageName) {
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
                    generateButtonRectangle(context, "Storage aktualisiern",
                        () async {
                      if (_formKey.currentState!.validate()) {
                        Storages newEntry = new Storages(
                            name: widget.stor.name,
                            location: widget.stor.location,
                            numberOfCards: widget.stor.numberOfCards,
                            cards: []);

                        Future<int> code =
                            updateStorage(widget.stor.name, newEntry.toJson());

                        if (await code == 200) {
                          Navigator.of(context).pop();
                        }
                        if (await code == 400) {
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
                                          "Es ist ein Fehler beim aktualisieren des Storages aufgetreten!",
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
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Ok",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .focusColor),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .secondaryHeaderColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                      ;
                    }),
                  ]),
                )),
          ],
        ),
      ),
    );
  }
}
