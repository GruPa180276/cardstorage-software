import 'package:admin_login/pages/widget/storages.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/domain/values/storage_values.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: The needs to be pushed to the API

StorageValues storageValues = new StorageValues();

class AddStorage extends StatefulWidget {
  const AddStorage({Key? key}) : super(key: key);

  @override
  State<AddStorage> createState() => _AddStorageState();
}

class _AddStorageState extends State<AddStorage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Storage hinzufügen",
                style: TextStyle(color: Theme.of(context).focusColor)),
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
  late Future<List<Storages>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void setName(String value) {
    storageValues.setName(value);
  }

  void setIPAdress(String value) {
    storageValues.setIpAdress(value);
  }

  void setNumberOfCards(int value) {
    storageValues.setNumberOfCards(value);
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
          List<Storages>? data = snapshot.data;
          return genereateFields(context, data);
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

  Widget genereateFields(BuildContext context, List<Storages>? data) {
    return Container(
      child: Column(children: [
        GenerateListTile(
          labelText: "Name",
          hintText: "",
          icon: Icons.storage,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setName,
        ),
        GenerateListTile(
          labelText: "IP Adresse",
          hintText: "",
          icon: Icons.network_wifi,
          regExp: r'([0-9\.])',
          function: this.setIPAdress,
        ),
        GenerateListTile(
          labelText: "Anzahl an Karten",
          hintText: "",
          icon: Icons.format_list_numbered,
          regExp: r'([0-9])',
          function: this.setNumberOfCards,
        ),
        GenerateListTile(
          labelText: "Ort",
          hintText: "",
          icon: Icons.location_pin,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setLocation,
        ),
        GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 70,
              child: Column(children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: generateButtonRectangle(
                    context,
                    "Storage hinzufügen",
                    storageValues,
                    () {
                      Storages newEntry = new Storages(
                          id: storageValues.id,
                          name: storageValues.name,
                          ipAdress: storageValues.ipAdress,
                          location: storageValues.location,
                          numberOfCards: storageValues.numberOfCards);
                      sendData(newEntry.toJson());
                    },
                  ),
                )
              ]),
            )),
      ]),
    );
  }
}
