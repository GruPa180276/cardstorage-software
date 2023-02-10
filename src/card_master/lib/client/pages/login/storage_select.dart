import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:card_master/client/config/palette.dart';
import 'package:card_master/client/pages/widgets/widget/default_custom_button.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/client/provider/rest/types/storage.dart';

class StorageSelectPopUp {
  static var _successful = false;
  static String _dropdownValue = "";
  static Future<void> build(BuildContext buildcontext) async {
    var responseStorage = await Data.check(Data.getReaderCards, null);

    var storagesJson = jsonDecode(responseStorage.body) as List;
    List<Storage> storageList =
        storagesJson.map((tagJson) => Storage.fromJson(tagJson)).toList();

    var storages = storageList.map((e) => e.name).toSet();

    // List<String> storages =
    //     readercards!.map((e) => e.storageName!).toSet().toList();

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
                          child: DefaultCustomButton(
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
                          child: DefaultCustomButton(
                            bgColor: ColorSelect.blueAccent,
                            borderColor: ColorSelect.blueAccent,
                            text: 'Abbrechen',
                            textColor: Colors.white,
                            onPress: () {
                              _successful = false;
                              Navigator.pop(context);
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
