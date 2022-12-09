import 'package:admin_login/provider/types/locations.dart';
import 'package:admin_login/provider/types/locations.dart' as location;
import 'package:flutter/material.dart';

import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/provider/types/storages.dart' as storage;
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/domain/values/storage_values.dart';

// ToDo: The Api needs to be changed in the future

StorageValues storageValues = new StorageValues();
late Future<List<Storages>> futureData;
int index = 0;

class StorageSettings extends StatefulWidget {
  StorageSettings(int id, {Key? key}) : super(key: key) {
    storageValues.setID(id);
    index = id;
  }

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  @override
  void initState() {
    super.initState();
    futureData = storage.fetchData();
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
  String selectedStorage = "-";
  List<Locations>? listOfLocations;
  List<String> dropDownValues = ["-"];
  List<String> dropDownValuesNames = ["-"];

  @override
  void initState() {
    super.initState();
    futureData = storage.fetchData();
    test();
  }

  void test() async {
    await location.fetchData().then((value) => listOfLocations = value);

    for (int i = 0; i < listOfLocations!.length; i++) {
      dropDownValues.add(listOfLocations![i].id.toString());
      dropDownValuesNames.add(listOfLocations![i].location.toString());
    }
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

  void setLocation(int value) {
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
          regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
          function: this.setName,
          state: true,
        ),
        GenerateListTile(
          labelText: "IP Adresse",
          hintText: data[storageValues.getId()].ipAdress,
          icon: Icons.network_wifi,
          regExp: r'([0-9\.])',
          function: this.setIPAdress,
          state: true,
        ),
        GenerateListTile(
          labelText: "Anzahl an Karten",
          hintText: data[storageValues.getId()].numberOfCards.toString(),
          icon: Icons.format_list_numbered,
          regExp: r'([0-9])',
          function: this.setNumberOfCards,
          state: true,
        ),
        GenerateListTile(
          labelText:
              "Location -> " + dropDownValuesNames[storageValues.getId() + 1],
          hintText: dropDownValuesNames[storageValues.getId() + 1],
          icon: Icons.location_pin,
          regExp: r'([0-9])',
          function: this.setLocation,
          state: false,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
                child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Center(
                        child: DropdownButton(
                      focusColor: Theme.of(context).focusColor,
                      dropdownColor: Theme.of(context).backgroundColor,
                      iconEnabledColor: Theme.of(context).focusColor,
                      iconDisabledColor: Theme.of(context).focusColor,
                      value: selectedStorage,
                      items: dropDownValuesNames.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem,
                            child: Text(
                              valueItem.toString(),
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ));
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedStorage = newValue as String;
                        });

                        int index =
                            dropDownValuesNames.indexOf(newValue as String);
                        setLocation(int.parse(dropDownValues[index]));
                      },
                    ))))
          ]),
        ),
        Container(
          padding: EdgeInsets.all(10),
          height: 70,
          child: Column(children: [
            generateButtonRectangle(
              context,
              "Location hinzufügen",
              () {
                Navigator.of(context).pushNamed("/addLocation");
              },
            ),
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
                  "Änderungen speichern",
                  () {
                    Storages newEntry = new Storages(
                        id: storageValues.id,
                        name: storageValues.name,
                        ipAdress: storageValues.ipAdress,
                        location: storageValues.location,
                        numberOfCards: storageValues.numberOfCards);
                    storage.updateData(newEntry.toJson());
                    Navigator.of(context).pop();
                  },
                ),
              ]),
            )),
      ]),
    ));
  }
}
