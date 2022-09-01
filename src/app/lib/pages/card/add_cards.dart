import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:app/config/color_values/tab3_color_values.dart';
import 'package:app/config/text_values/tab3_text_values.dart';
import 'package:app/domain/values/tab3_card_values.dart';

// ToDo: The needs to be pushed to the API
// Add API call to select the Card Storage

Tab3StorageSettingsValuesProvider tab3SSVP =
    new Tab3StorageSettingsValuesProvider();
Tab3AddStorageDescriptionProvider tab3ASDP =
    new Tab3AddStorageDescriptionProvider();
Tab3AddStorageColorProvider tab3ASCP = new Tab3AddStorageColorProvider();

class AddCards extends StatefulWidget {
  const AddCards({Key? key}) : super(key: key);

  @override
  State<AddCards> createState() => _AddCardsState();
}

class _AddCardsState extends State<AddCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(tab3ASDP.getAppBarTitle()),
          backgroundColor: tab3ASCP.getAppBarColor(),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.description),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z\-\_\ö\ä\ü\ß ])'))
            ],
            decoration: InputDecoration(
                labelText: tab3ASDP.getNameFieldName(),
                labelStyle: TextStyle(color: Colors.blueGrey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                )),
            onChanged: (value) => tab3SSVP.setName(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z\-\_\ö\ä\ü\ß ])'))
            ],
            decoration: InputDecoration(
                labelText: tab3ASDP.getCardStorageFieldName(),
                labelStyle: TextStyle(color: Colors.blueGrey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                )),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab3SSVP.setCardStorage(value),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          height: 70,
          child: Column(children: [
            SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context),
                    );
                  },
                  child: Text(tab3ASDP.getHardwareIDofCardFieldName()),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ))
          ]),
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
                        if (tab3SSVP.getCardStorage() != "" &&
                            tab3SSVP.getHardwareID() != "" &&
                            tab3SSVP.getName() != "") {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(tab3ASDP.getButtonName()),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
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

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Karte hinzufügen'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Gehen Sie bitte zum Kartenlesegerät am Kartenautomaten und halte Sie die jeweilige Karte vor den Scanner ..."),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          height: 70,
          child: Column(children: [
            SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // ToDo: Implment Call, to start the Scanner
                    tab3SSVP.setHardwareID("hardwareID");
                    if (tab3SSVP.getHardwareID() != "") {
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Abschließen"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ))
          ]),
        ),
      ],
    );
  }
}
