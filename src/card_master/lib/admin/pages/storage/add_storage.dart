import 'dart:convert';

import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/user.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/provider/types/storages.dart';

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
    var response = await Data.checkAuthorization(
      context: context,
      function: fetchStorages,
    );
    var temp = jsonDecode(response!.body) as List;
    s = temp.map((e) => Storages.fromJson(e)).toList();
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
                          Storages newEntry = Storages(
                              name: stor.name,
                              location: stor.location,
                              numberOfCards: stor.numberOfCards,
                              cards: []);

                          await Data.checkAuthorization(
                              context: context,
                              function: addStorage,
                              args: {"name": "", 'data': newEntry.toJson()});

                          Users newUser = Users(
                            email: newEntry.name.toLowerCase() + "@default.com",
                            storage: stor.name,
                            privileged: false,
                          );

                          await Data.checkAuthorization(
                              context: context,
                              function: addUser,
                              args: {"name": "", 'data': newUser.toJson()});
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
