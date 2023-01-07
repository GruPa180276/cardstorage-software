import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/readercards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class BottomSheetPop {
  String _valueStorage = '';
  dynamic _valueAvailable = 'alle';
  final Function(Future<List<Storage>?>?) onPressStorage;
  Future<List<Storage>?>? defaultStorage;
  Future<List<Storage>?>? modifiedStorage;

  BottomSheetPop({
    Key? key,
    required this.defaultStorage,
    required this.onPressStorage,
  });

  Future buildBottomSheet(BuildContext context) async {
    List<String> listOfStorageId = await _getStorageNames();
    final _listofAvailable = ['alle', true, false];

    listOfStorageId.insert(0, "alle");
    _valueStorage = listOfStorageId.first;
    //TODO getStorageIds by API
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
                height: 300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                child: Column(children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 30),
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: Text(
                        'Storage',
                        style: TextStyle(fontSize: 17),
                      )),
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          value: _valueStorage,
                          items: listOfStorageId.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem,
                                child: Container(
                                    child: Text(valueItem.toString())));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _valueStorage = newValue as String;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Verfuegabar',
                        style: TextStyle(fontSize: 17),
                      )),
                      Expanded(
                        child: DropdownButton(
                          value: _valueAvailable,
                          items: _listofAvailable.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem.toString()));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue != 'alle') {
                                _valueAvailable = newValue as bool;
                              } else {
                                _valueAvailable = newValue as dynamic;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: double.infinity,
                    height: 50,
                    child: buttonField(
                        bgColor: ColorSelect.blueAccent,
                        borderColor: ColorSelect.blueAccent,
                        text: 'Filtern',
                        onPress: () {
                          //Improve logic readability
                          modifiedStorage = defaultStorage!.then((value) {
                            if (_valueAvailable.toString() == "alle" &&
                                _valueStorage.toString() == "alle") {
                              return value;
                            } else if (_valueAvailable.toString() == "alle") {
                              return value!
                                  .where((element) =>
                                      element.name == _valueStorage)
                                  .toList();
                            } else if (_valueStorage.toString() == "alle") {
                              return value;
                              // .where((element) =>
                              //     element.cards.map((e) => e.available==_valueAvailable))
                              // .toList();
                            }
                            return value;
                            //       .where((element) =>
                            //           element.name == _valueStorage &&
                            //           element.available == _valueAvailable)
                            //       .toList();
                          });
                          onPressStorage(modifiedStorage);
                        },
                        textColor: Colors.white),
                  )
                ]));
          });
        });
  }

  Future<List<String>> _getStorageNames() async {
    var storages = await defaultStorage;
    List<String> storagenames = storages!.map((e) => e.name).toList();
    return storagenames;
  }
}
