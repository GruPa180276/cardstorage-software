import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:app/config/color_values/tab2_color_values.dart';
import 'package:app/config/text_values/tab2_text_values.dart';
import 'package:app/domain/values/tab2_storage_values.dart';

// ToDo: The needs to be pushed to the API

Tab2StorageValuesProvider tab2SSVP = new Tab2StorageValuesProvider();
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
            title: Text(tab2ASDP.getAppBarTitle(),
                style: TextStyle(color: Theme.of(context).focusColor)),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ListTile(
          leading: Icon(
            Icons.description,
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z\-\_\ö\ä\ü\ß ])'))
            ],
            decoration: InputDecoration(
                labelText: tab2ASDP.getNameFieldName(),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
            onChanged: (value) => tab2SSVP.setName(value),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.network_wifi,
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9\.])'))
            ],
            decoration: InputDecoration(
                labelText: tab2ASDP.getIpAdressFieldName(),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab2SSVP.setIpAdress(value),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.format_list_numbered,
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9])'))
            ],
            decoration: InputDecoration(
                labelText: tab2ASDP.getNumberOfCardsFieldName(),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab2SSVP.setNumberOfCards(value),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.location_pin,
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z\-\_\ö\ä\ü\ß ])'))
            ],
            decoration: InputDecoration(
                labelText: tab2ASDP.getLocationFieldName(),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
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
                        if (tab2SSVP.getName() != "" &&
                            tab2SSVP.getIpAdress() != "" &&
                            tab2SSVP.getLocation() != "" &&
                            tab2SSVP.getNumberOfCards() != "")
                          Navigator.pop(context);
                      },
                      child: Text(
                        tab2ASDP.getButtonName(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).secondaryHeaderColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ))
              ]),
            )),
      ]),
    );
  }
}
