import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../values/tab2_storage_values.dart';
import '../text/tab2_text_values.dart';
import '../color/tab2_color_values.dart';

// ToDo: The needs to be pushed to the API

Tab2StorageSettingsValuesProvider tab2SSVP =
    new Tab2StorageSettingsValuesProvider();
Tab2AddStorageDescriptionProvider tab2ASDP =
    new Tab2AddStorageDescriptionProvider();
Tab2AddStorageColorProvider tab2ASCP = new Tab2AddStorageColorProvider();

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
            title: Text(tab2ASDP.getAppBarTitle()),
            backgroundColor: tab2ASCP.getAppBarColor(),
            actions: []),
        body: SingleChildScrollView(
          child: Container(
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
              labelText: tab2ASDP.getNameFieldName(),
            ),
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
              labelText: tab2ASDP.getIpAdressFieldName(),
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
              labelText: tab2ASDP.getNumberOfCardsFieldName(),
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
              labelText: tab2ASDP.getLocationFieldName(),
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
                      child: Text(tab2ASDP.getButtonName()),
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
    );
  }
}
