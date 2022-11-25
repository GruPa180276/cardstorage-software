import 'package:flutter/material.dart';

import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/domain/values/storage_values.dart';

// ToDo: The Api needs to be changed in the future

StorageValues storageValues = new StorageValues();

class StorageSettings extends StatefulWidget {
  StorageSettings(int id, {Key? key}) : super(key: key) {
    storageValues.setID(id);
  }

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Storage bearbeiten",
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [GetDataFromAPI()],
              )),
        ));
  }
}

class GetDataFromAPI extends StatefulWidget {
  const GetDataFromAPI({Key? key}) : super(key: key);

  @override
  State<GetDataFromAPI> createState() => _GetDataFromAPIState();
}

class _GetDataFromAPIState extends State<GetDataFromAPI> {
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
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).focusColor),
            )
          ],
        )));
      },
    );
  }

  Widget genereateFields(BuildContext context, List<Storages>? data) {
    return InkWell(
        child: Container(
      child: Column(children: [
        GenerateListTile(
          labelText: "Name",
          hintText: data![storageValues.getId()].name,
          icon: Icons.storage,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setName,
        ),
        GenerateListTile(
          labelText: "IP Adresse",
          hintText: data[storageValues.getId()].id.toString(),
          icon: Icons.network_wifi,
          regExp: r'([0-9\.])',
          function: this.setIPAdress,
        ),
        GenerateListTile(
          labelText: "Anzahl an Karten",
          hintText: data[storageValues.getId()].id.toString(),
          icon: Icons.format_list_numbered,
          regExp: r'([0-9])',
          function: this.setNumberOfCards,
        ),
        GenerateListTile(
          labelText: "Ort",
          hintText: data[storageValues.getId()].name.toString(),
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
                    "Änderungen speichern",
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
    ));
  }
}
