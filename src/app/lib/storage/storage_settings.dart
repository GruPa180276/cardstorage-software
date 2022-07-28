import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../values/tab2_storage_values.dart';

// ToDo: The Api needs to be changed in the future

Tab2StorageSettingsValuesProvider tab2SSVP =
    new Tab2StorageSettingsValuesProvider();

class StorageSettings extends StatefulWidget {
  StorageSettings(int id, {Key? key}) : super(key: key) {
    tab2SSVP.setID(id);
  }

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Storage Settings"),
          backgroundColor: Colors.blueGrey,
          actions: []),
      body: SingleChildScrollView(
          child: Container(
              child: Column(
        children: [InputFields()],
      ))),
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
          return createStorage(context, data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget createStorage(BuildContext context, List<Data>? data) {
    return InkWell(
        child: Container(
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.description),
          title: TextField(
            decoration: InputDecoration(
                labelText: "Name", hintText: data![tab2SSVP.getId()].title),
            onChanged: (value) => tab2SSVP.setName(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.network_wifi),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9\.])'))
            ],
            decoration: InputDecoration(
              labelText: "Ip-Adresse",
              hintText: data[tab2SSVP.getId()].id.toString(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab2SSVP.setIpAdress(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.format_list_numbered),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9])'))
            ],
            decoration: InputDecoration(
              labelText: "Anzahl Karten",
              hintText: data[tab2SSVP.getId()].id.toString(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab2SSVP.setNumberOfCards(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.location_pin),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([A-Za-z0-9\-\_ ])'))
            ],
            decoration: InputDecoration(
              labelText: "Ort",
              hintText: data[tab2SSVP.getId()].title.toString(),
            ),
            onChanged: (value) => tab2SSVP.setLocation(value),
          ),
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Änderungen speichern'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ))
              ]),
            )),
        Text("Name: " +
            tab2SSVP.getName() +
            "\n IP-Adress: " +
            tab2SSVP.getIpAdress() +
            "\n Number of Cards: " +
            tab2SSVP.getNumberOfCards() +
            "\n Ort: " +
            tab2SSVP.getLocation())
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
