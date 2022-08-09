import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../values/tab4_user_values.dart';
import '../text/tab4_text_values.dart';
import '../color/tab4_color_values.dart';

// ToDo: The needs to be pushed to the API

Tab4StorageSettingsValuesProvider tab4SSVP =
    new Tab4StorageSettingsValuesProvider();
Tab4AddStorageDescriptionProvider tab4ASDP =
    new Tab4AddStorageDescriptionProvider();
Tab4AddStorageColorProvider tab4ASCP = new Tab4AddStorageColorProvider();

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
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
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z0-9\-\_\ö\ä\ü ])'))
            ],
            decoration: InputDecoration(
              labelText: tab4ASDP.getFirstNameFieldName(),
            ),
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
            ),
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
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => tab4SSVP.setUserMail(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.format_list_numbered),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9\- ])'))
            ],
            decoration: InputDecoration(
              labelText: tab4ASDP.getPhoneFieldName(),
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
                        if (tab4SSVP.getFirstName() != "" &&
                            tab4SSVP.getLastName() != "" &&
                            tab4SSVP.getPhoneNumber() != "" &&
                            tab4SSVP.getUserMail() != "")
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
    );
  }
}
