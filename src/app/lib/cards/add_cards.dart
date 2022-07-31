import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../values/tab3_card_values.dart';
import '../text/tab3_text_values.dart';
import '../color/tab3_color_values.dart';

// ToDo: The needs to be pushed to the API

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
        ListTile(
          leading: const Icon(Icons.format_list_numbered),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9])'))
            ],
            decoration: InputDecoration(
              labelText: tab3ASDP.getHardwareIDofCardFieldName(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab3SSVP.setHardwareID(value),
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
                      child: Text(tab3ASDP.getButtonName()),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ))
              ]),
            )),
        Text("Name: " +
            tab3SSVP.getName() +
            "\n IP-Adress: " +
            tab3SSVP.getCardStorage() +
            "\n Number of Cards: " +
            tab3SSVP.getHardwareID())
      ]),
    );
  }
}
