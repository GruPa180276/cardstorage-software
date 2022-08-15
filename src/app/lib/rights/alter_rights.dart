import 'package:app/color/tab5_color_values.dart';
import 'package:app/text/tab5_text_values.dart';
import 'package:app/values/tab5_rights_values.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../values/tab5_rights_values.dart';
import '../text/tab5_text_values.dart';
import '../color/tab5_color_values.dart';

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
        appBar: AppBar(
            title: Text(tab5ASDP.getAppBarTitle()),
            backgroundColor: tab5ASCP.getAppBarColor(),
            actions: []),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  InputFields(),
                  Divider(
                    color: tab5ASCP.getAppBarColor(),
                    height: 0,
                    thickness: 2,
                    indent: 5,
                    endIndent: 5,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text("Rechte anzeigen"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
                ])),
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              bottom: 22,
              child: DropDownValues(),
            )
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
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                for (int i = 0; i < selectedValues.length; i++) {
                  if (selectedValues[i] == data![index].title) {
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
      storageState = Text("Verfügbar", style: const TextStyle(fontSize: 20));
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
      storageIcon = Icons.event_available;
    } else if (apiCall == "y") {
      storageIcon = Icons.event_busy;
    }
    return Positioned(left: 100, top: 30, child: Icon(storageIcon));
  }

  Widget createStorage(BuildContext context, List<Data>? data, int index) {
    return InkWell(
      child: Container(
        height: 70,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Colors.blueGrey,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned(
              left: 100,
              child: Text(data![index].title,
                  style: const TextStyle(fontSize: 20))),
          setStateOdCardStorage(data[index].title.toString()),
          setCardStorageIcon(data[index].title.toString()),
          const Positioned(
              left: 15,
              top: 7,
              child: Icon(
                Icons.account_box_outlined,
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
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;

          for (int i = 0; i < data!.length; i++) {
            if (data[i].title == tab5SSVP.getCallerName()) {
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

  Widget createStorage(BuildContext context, int index, List<Data>? data) {
    return InkWell(
        child: Container(
      child: Column(children: [
        Positioned(
            top: 75,
            left: 0,
            right: 0,
            bottom: 22,
            child: Stack(children: [
              Container(
                  height: 80,
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
            ])),
        Divider(
          color: tab5ASCP.getAppBarColor(),
          height: 30,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              height: 70,
              child: Column(children: [
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(tab5ASDP.getButtonName()),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ))
              ]),
            )),
      ]),
    ));
  }
}

Future<List<Data>> fetchData() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final int userId;
  final int id;
  final String title;

  Data({required this.userId, required this.id, required this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
