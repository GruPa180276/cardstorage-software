import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/domain/values/storage_values.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

StorageValues storageValues = new StorageValues();
late Future<List<Storages>> futureData;

class AddStorage extends StatefulWidget {
  const AddStorage({Key? key}) : super(key: key);

  @override
  State<AddStorage> createState() => _AddStorageState();
}

class _AddStorageState extends State<AddStorage> {
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Storage hinzufügen",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [InputFields()],
              )),
        ));
  }
}

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void setName(String value) {
    storageValues.setName(value);
  }

  void setNumberOfCards(String value) {
    storageValues.setNumberOfCards(int.parse(value));
  }

  void setLocation(String value) {
    storageValues.setLocation(value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Storages>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return genereateFields(context);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: Container(
                child: Column(
          children: [
            generateProgressIndicator(context),
          ],
        )));
      },
    );
  }

  Widget genereateFields(BuildContext context) {
    return Container(
      child: Column(children: [
        GenerateListTile(
          labelText: "Name",
          hintText: "",
          icon: Icons.storage,
          regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
          function: this.setName,
        ),
        GenerateListTile(
          labelText: "Standort",
          hintText: "",
          icon: Icons.location_city,
          regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
          function: this.setLocation,
        ),
        GenerateListTile(
          labelText: "Anzahl an Karten",
          hintText: "",
          icon: Icons.format_list_numbered,
          regExp: r'([0-9])',
          function: this.setNumberOfCards,
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
                  () {
                    Storages newEntry = new Storages(
                        name: storageValues.name,
                        location: storageValues.location,
                        numberOfCards: storageValues.numberOfCards,
                        cards: []);
                    sendData(newEntry.toJson());
                    Navigator.of(context).pop();
                  },
                ),
              ]),
            )),
      ]),
    );
  }
}
