import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/local_notification.dart';
import 'package:rfidapp/pages/cards/cards_page.dart';
import 'package:rfidapp/pages/generate/Widget/mqtt_timer.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/pages/login/login_user_page.dart';
import 'package:rfidapp/pages/navigation/bottom_navigation.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/storage.dart';

class StorageSelectPopUp {
  static var _successful = false;
  static String dropdownValue = "";
  static Future<void> build(BuildContext buildcontext) async {
    List<String>? storages = await Data.getStorageNames();
    dropdownValue = storages.first;

    return showDialog(
        context: buildcontext,
        builder: (buildcontext) {
          return Container(
            height: 100,
            child: AlertDialog(
                title: const Text('Waehlen Sie einen Storage aus'),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    height: 218,
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                          "Sie muessen Ihre Karte nun auf einen Storage halten um sich vollstaendig zu registrieren",
                          textAlign: TextAlign.center,
                        )),
                        DropdownButtonFormField<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: TextStyle(color: ColorSelect.blueAccent),
                          validator: (value) =>
                              value == null ? 'field required' : null,
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: storages
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        ConstrainedBox(
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          child: buttonField(
                              bgColor: ColorSelect.blueAccent,
                              borderColor: ColorSelect.blueAccent,
                              text: 'Weiter',
                              textColor: Colors.white,
                              onPress: () async {     
                                _successful=true;                          
                                  Navigator.pop(context);
                              }),
                        ),
                        ConstrainedBox(
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          child: buttonField(
                            bgColor: ColorSelect.blueAccent,
                            borderColor: ColorSelect.blueAccent,
                            text: 'Abbrechen',
                            textColor: Colors.white,
                            onPress: () {
                              _successful = false;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CardPage()));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                })),
          );
        });
  }

  // static Widget _dropDownStorages(
  //     BuildContext context, List<String> storages, StateSetter setState) {
  //   return
  // }

  static bool getSuccessful() {
    return _successful;
  }
}
