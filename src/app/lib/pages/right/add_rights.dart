import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/config/color_values/tab5_color_values.dart';
import 'package:app/config/text_values/tab5_text_values.dart';
import 'package:app/domain/values/tab5_rights_values.dart';

// ToDo: The needs to be pushed to the API

Tab5RightsValuesProvider tab5SSVP = new Tab5RightsValuesProvider();
Tab5AddRightsDescriptionProvider tab5ASDP =
    new Tab5AddRightsDescriptionProvider();
Tab5AddRightsColorProvider tab5ASCP = new Tab5AddRightsColorProvider();

class AddRights extends StatefulWidget {
  const AddRights({Key? key}) : super(key: key);

  @override
  State<AddRights> createState() => _AddRightsState();
}

class _AddRightsState extends State<AddRights> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(tab5ASDP.getAppBarTitle()),
            backgroundColor: tab5ASCP.getAppBarColor(),
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
          leading: const Icon(Icons.announcement),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'([A-Za-z0-9\-\_\ö\ä\ü ])'))
            ],
            decoration: InputDecoration(
              labelText: tab5ASDP.getRightsFieldName(),
            ),
            onChanged: (value) => tab5SSVP.setRightsName(value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add_task),
          title: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([A-Za-z0-9\-\_ ])'))
            ],
            decoration: InputDecoration(
              labelText: tab5ASDP.getAccessFieldName(),
            ),
            onChanged: (value) => tab5SSVP.setAccessName(value),
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
                        if (tab5SSVP.getRightsName() != "" &&
                            tab5SSVP.getAccessName() != "")
                          Navigator.pop(context);
                      },
                      child: Text(tab5ASDP.getButtonName()),
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
}
