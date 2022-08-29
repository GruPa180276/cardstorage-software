import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:app/config/color_values/tab5_color_values.dart';
import 'package:app/config/text_values/tab5_text_values.dart';
import 'package:app/domain/values/tab5_rights_values.dart';

import 'package:app/provider/api/data_API.dart';
import 'package:app/provider/types/card.dart';

// ToDo: The Api needs to be changed in the future

Tab5RightsValuesProvider tab5SSVP = new Tab5RightsValuesProvider();
Tab5AlterRightsDescriptionProvider tab5ASDP =
    new Tab5AlterRightsDescriptionProvider();
Tab5AddRightsColorProvider tab5ASCP = new Tab5AddRightsColorProvider();

List<String> selectedValues = [];

class RightsSettings extends StatefulWidget {
  RightsSettings(String id, List<String> values, {Key? key}) : super(key: key) {
    tab5SSVP.setCallerName(id);
    tab5ASDP.setDropDownValues(values);
    tab5ASDP.setDropDownText(values.first);
  }

  @override
  State<RightsSettings> createState() => _RightsSettingsState();
}

class _RightsSettingsState extends State<RightsSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Icon(Icons.refresh),
                ),
              ),
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(tab5ASDP.getAppBarTitle()),
          backgroundColor: tab5ASCP.getAppBarColor(),
        ),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  InputFields(),
                ])),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 22,
              child: DropDownValues(),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton.extended(
                  label: Text("Add"),
                  icon: Icon(Icons.add),
                  backgroundColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.extended(
                  label: Text("Remove"),
                  icon: Icon(Icons.add),
                  backgroundColor: Colors.blueGrey,
                  onPressed: () {
                    // ToDo
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class DropDownValues extends StatefulWidget {
  const DropDownValues({Key? key}) : super(key: key);

  @override
  State<DropDownValues> createState() => _DropDownValuesState();
}

class _DropDownValuesState extends State<DropDownValues> {
  late Future<List<Cards>> futureData;

  @override
  void initState() {
    super.initState();
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      futureData = Data.getData("card").then((value) =>
          jsonDecode(value.body).map<Cards>(Cards.fromJson).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cards>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cards>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                for (int i = 0; i < selectedValues.length; i++) {
                  if (selectedValues[i] == data![index].name) {
                    return createStorage(context, data, index);
                  }
                }
                return SizedBox.shrink();
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget setStateOdCardStorage(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    Widget storageState = Text("");
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageState =
          Text("Zugriff auf ...", style: const TextStyle(fontSize: 20));
    } else if (apiCall == "y") {
      storageState =
          Text("Nicht verfügbar", style: const TextStyle(fontSize: 20));
    }
    return Positioned(left: 140, top: 30, child: storageState);
  }

  Widget setCardStorageIcon(String storage) {
    // ignore: unused_local_variable
    String storageName = storage;
    IconData storageIcon = Icons.not_started;
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      storageIcon = Icons.task;
    } else if (apiCall == "y") {
      storageIcon = Icons.event_busy;
    }
    return Positioned(left: 100, top: 30, child: Icon(storageIcon));
  }

  Widget createStorage(BuildContext context, List<Cards>? data, int index) {
    return InkWell(
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Colors.blueGrey,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned(
              left: 100,
              child: Text(data![index].name.toString(),
                  style: const TextStyle(fontSize: 20))),
          setStateOdCardStorage(data[index].id.toString()),
          setCardStorageIcon(data[index].id.toString()),
          const Positioned(
              left: 15,
              top: 7,
              child: Icon(
                Icons.task,
                size: 50,
              ))
        ]),
      ),
      onTap: () {},
    );
  }
}

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  late Future<List<Cards>> futureData;

  @override
  void initState() {
    super.initState();
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      futureData = Data.getData("card").then((value) =>
          jsonDecode(value.body).map<Cards>(Cards.fromJson).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cards>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cards>? data = snapshot.data;

          for (int i = 0; i < data!.length; i++) {
            if (data[i].name == tab5SSVP.getCallerName()) {
              return createStorage(context, data[i].id - 1, data);
            }
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  String dropDownText = tab5ASDP.getDropDownText();
  var dropDownValues = tab5ASDP.getDropDownValues();

  Widget createStorage(BuildContext context, int index, List<Cards>? data) {
    return InkWell(
      child: Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: tab5ASCP.getAppBarColor(),
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: <Widget>[
              DropdownButton(
                value: dropDownText,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 30,
                underline: Container(
                  height: 2,
                  color: tab5ASCP.getAppBarColor(),
                ),
                items: dropDownValues.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    alignment: Alignment.center,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedValues.add(newValue!);
                  dropDownText = newValue;
                },
              ),
            ],
          )),
    );
  }
}
