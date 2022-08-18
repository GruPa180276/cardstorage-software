import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../values/tab3_card_values.dart';
import '../text/tab3_text_values.dart';
import '../color/tab3_color_values.dart';

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
              labelText: tab3ASDP.getNameFieldName(),
            ),
            onChanged: (value) => tab3SSVP.setName(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([A-Za-z0-9\-\_ ])'))
            ],
            decoration: InputDecoration(
              labelText: tab3ASDP.getCardStorageFieldName(),
            ),
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
