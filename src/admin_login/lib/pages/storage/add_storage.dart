import 'package:admin_login/provider/types/storages.dart' as storage;
import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/provider/types/locations.dart' as location;
import 'package:admin_login/provider/types/locations.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/domain/values/storage_values.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: The needs to be pushed to the API

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
    futureData = storage.fetchData();
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
          state: true,
        ),
        GenerateListTile(
          labelText: "IP Adresse",
          hintText: "",
          icon: Icons.network_wifi,
          regExp: r'([0-9\.])',
          function: this.setIPAdress,
          state: true,
        ),
        GenerateListTile(
          labelText: "Anzahl an Karten",
          hintText: "",
          icon: Icons.format_list_numbered,
          regExp: r'([0-9])',
          function: this.setNumberOfCards,
          state: true,
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
                  "Storage hinzufügen",
                  () {
                    Storages newEntry = new Storages(
                        id: 0,
                        name: storageValues.name,
                        ipAdress: storageValues.ipAdress,
                        location: storageValues.location,
                        numberOfCards: storageValues.numberOfCards);
                    storage.sendData(newEntry.toJson());
                    Navigator.of(context).pop();
                  },
                ),
              ]),
            )),
      ]),
    );
  }
}
