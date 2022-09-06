import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:app/domain/values/tab3_card_values.dart';

// ToDo: The needs to be pushed to the API
// Add API call to select the Card Storage

Tab3StorageSettingsValuesProvider tab3SSVP =
    new Tab3StorageSettingsValuesProvider();

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
            title: Text(
              "Admin Login",
              style: TextStyle(color: Theme.of(context).focusColor),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ListTile(
          leading:
              Icon(Icons.description, color: Theme.of(context).primaryColor),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z\-\_\ö\ä\ü\ß ])'))
            ],
            decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )),
            onChanged: (value) => tab3SSVP.setName(value),
          ),
        ),
        ListTile(
          leading: Icon(Icons.storage, color: Theme.of(context).primaryColor),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z\-\_\ö\ä\ü\ß ])'))
            ],
            decoration: InputDecoration(
                labelText: "Karten Tresor",
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                  child: Text(
                    "Bitte Karte scannen",
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
                      child: Text(
                        "Karte hinzufügen",
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

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Karte hinzufügen',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Gehen Sie bitte zum Kartenlesegerät am Kartenautomaten und halte Sie die jeweilige Karte vor den Scanner ...",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
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
                  child: Text(
                    "Abschließen",
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
        ),
      ],
    );
  }
}
