import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/domain/values/storage_values.dart';

// ToDo: The Api needs to be changed in the future

StorageValues storageValues = new StorageValues();
late Future<List<Storages>> futureData;
String storageName = "";

class StorageSettings extends StatefulWidget {
  StorageSettings(String storage, {Key? key}) : super(key: key) {
    storageName = storage;
  }

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
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
                  child: Column(children: [GetDataFromAPI()])),
            )
          ]),
        ));
  }
}

class GetDataFromAPI extends StatefulWidget {
  const GetDataFromAPI({Key? key}) : super(key: key);

  @override
  State<GetDataFromAPI> createState() => _GetDataFromAPIState();
}

class _GetDataFromAPIState extends State<GetDataFromAPI> {
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void setName(String value) {
    storageValues.setName(value);
  }

  void setNumberOfCards(int value) {
    storageValues.setNumberOfCards(value);
  }

  void setLocation(String value) {
    storageValues.setLocation(value);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Storages>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Storages>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                if (data![index].name == storageName) {
                  return genereateFields(context, data[index]);
                } else {
                  return const SizedBox.shrink();
                }
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: Container(
                child: Column(
          children: [
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).focusColor),
            )
          ],
        )));
      },
    ));
  }

  Widget genereateFields(BuildContext context, Storages data) {
    return InkWell(
        child: Container(
      child: Column(children: [
        GenerateListTile(
          labelText: "Name",
          hintText: data.name,
          icon: Icons.storage,
          regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
          function: this.setName,
        ),
        GenerateListTile(
          labelText: "Standort",
          hintText: data.location,
          icon: Icons.storage,
          regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
          function: this.setLocation,
        ),
        GenerateListTile(
          labelText: "Anzahl an Karten",
          hintText: data.numberOfCards.toString(),
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
                  "Änderungen speichern",
                  () {
                    Storages newEntry = new Storages(
                        name: storageValues.name,
                        location: storageValues.location,
                        numberOfCards: storageValues.numberOfCards);
                    updateData(storageValues.name, newEntry.toJson());
                    Navigator.of(context).pop();
                  },
                ),
              ]),
            )),
      ]),
    ));
  }
}
