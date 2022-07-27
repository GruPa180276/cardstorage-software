import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          title: const Text("Add Storage"),
          backgroundColor: Colors.blueGrey,
          actions: []),
      body: Container(
          child: Column(
        children: [InputFields()],
      )),
    );
  }
}

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  String name = "";
  String ipAdress = "";
  String numberOfCards = "";
  String ort = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.description),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([A-Za-z0-9\-\_ ])'))
            ],
            decoration: InputDecoration(
              hintText: "Name",
            ),
            onChanged: (value) => name = value,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.network_wifi),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9\.])'))
            ],
            decoration: InputDecoration(
              hintText: "IP-Adress",
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => ipAdress = value,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.format_list_numbered),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9])'))
            ],
            decoration: InputDecoration(
              hintText: "Anzahl Karten",
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => numberOfCards = value,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.location_pin),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([A-Za-z0-9\-\_ ])'))
            ],
            decoration: InputDecoration(
              hintText: "Ort",
            ),
            onChanged: (value) => ort = value,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SizedBox(
                width: 370,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Automat hinzufügen'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ))),
        Text("Name: " +
            name +
            "\n IP-Adress: " +
            ipAdress +
            "\n Number of Cards: " +
            numberOfCards +
            "\n Ort: " +
            ort)
      ]),
    );
  }
}
