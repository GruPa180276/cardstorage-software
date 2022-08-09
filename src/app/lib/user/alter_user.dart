import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../values/tab4_user_values.dart';
import '../text/tab4_text_values.dart';
import '../color/tab4_color_values.dart';

// ToDo: The Api needs to be changed in the future

Tab4StorageSettingsValuesProvider tab4SSVP =
    new Tab4StorageSettingsValuesProvider();
Tab4AlterStorageDescriptionProvider tab4ASDP =
    new Tab4AlterStorageDescriptionProvider();
Tab4AlterStorageColorProvider tab4ASCP = new Tab4AlterStorageColorProvider();

class UserSettings extends StatefulWidget {
  UserSettings(String id, {Key? key}) : super(key: key) {
    tab4SSVP.setCallerName(id);
  }

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(tab4ASDP.getAppBarTitle()),
          backgroundColor: tab4ASCP.getAppBarColor(),
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

          for (int i = 0; i < data!.length; i++) {
            if (data[i].title == tab4SSVP.getCallerName()) {
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

  Widget createStorage(BuildContext context, int index, List<Data>? data) {
    return InkWell(
        child: Container(
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.description),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z0-9\-\_\ö\ä\ü ])'))
            ],
            decoration: InputDecoration(
                labelText: tab4ASDP.getFirstNameFieldName(),
                hintText: data![index].title),
            onChanged: (value) => tab4SSVP.setFirstName(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z0-9\-\_\ö\ä\ü ])'))
            ],
            decoration: InputDecoration(
                labelText: tab4ASDP.getLastNameFieldName(),
                hintText: data[index].title),
            onChanged: (value) => tab4SSVP.setLastName(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.mail),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z0-9\-\_\@\. ])'))
            ],
            decoration: InputDecoration(
              labelText: tab4ASDP.getMailFieldName(),
              hintText: data[index].title.toString(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab4SSVP.setUserMail(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.numbers),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9\- ])'))
            ],
            decoration: InputDecoration(
              labelText: tab4ASDP.getPhoneFieldName(),
              hintText: data[index].id.toString(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab4SSVP.setPhoneNumber(value),
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
                      child: Text(tab4ASDP.getButtonName()),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ))
              ]),
            )),
        Text("Vorname: " +
            tab4SSVP.getFirstName() +
            "\n Lastname: " +
            tab4SSVP.getLastName() +
            "\n Mail: " +
            tab4SSVP.getUserMail() +
            "\n Telefunnummer: " +
            tab4SSVP.getPhoneNumber())
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
