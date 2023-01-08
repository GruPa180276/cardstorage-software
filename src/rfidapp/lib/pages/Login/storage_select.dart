import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/cards/cards_page.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';

import 'package:rfidapp/provider/restApi/data.dart';

class StorageSelectPopUp {
  static var _successful = false;
  static String _dropdownValue = "";
  static Future<void> build(BuildContext buildcontext) async {
    var readercards = await Data.getReaderCards();
    List<String> storages =
        readercards!.map((e) => e.storageName!).toSet().toList();

    _dropdownValue = storages.first;

    return showDialog(
        context: buildcontext,
        builder: (buildcontext) {
          return SizedBox(
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
                        const Center(
                            child: Text(
                          "Sie muessen Ihre Karte nun auf einen Storage halten um sich vollstaendig zu registrieren",
                          textAlign: TextAlign.center,
                        )),
                        DropdownButtonFormField<String>(
                          value: _dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: TextStyle(color: ColorSelect.blueAccent),
                          onChanged: (String? value) {
                            setState(() {
                              _dropdownValue = value!;
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
                                _successful = true;
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
                                          const CardPage()));
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

  static bool getSuccessful() {
    return _successful;
  }

  static String getSelectedStorage() {
    return _dropdownValue;
  }
}
