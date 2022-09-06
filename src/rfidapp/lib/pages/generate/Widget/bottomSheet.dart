import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/provider/types/cards.dart';

class BottomSheetPop {
  dynamic? valueStorage = '';
  dynamic? valueAvailable = '';
  List<dynamic> listOfStorageId = ['', 1117, 1118];
  List<dynamic> listofAvailable = ['', true, false];
  final Function(Future<List<Cards>>) onPressStorage;
  final Function reloadList;
  Future<List<Cards>> listOfTypes;
  Future<List<Cards>>? newListOfCards;

  BottomSheetPop(
      {Key? key,
      required this.listOfTypes,
      required this.onPressStorage,
      required this.reloadList});

  Future buildBottomSheet(BuildContext context) {
    //TODO getStorageIds by API
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                child: Column(children: [
                  Text(
                    'Filter',
                    style: TextStyle(fontSize: 30),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Storage',
                        style: TextStyle(fontSize: 17),
                      )),
                      DropdownButton(
                        value: valueStorage,
                        items: listOfStorageId.map((valueItem) {
                          return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue != '') {
                              valueStorage = newValue as int;
                            } else {
                              valueStorage = newValue as dynamic;
                            }
                          });
                        },
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
                      DropdownButton(
                        value: valueAvailable,
                        items: listofAvailable.map((valueItem) {
                          return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue != '') {
                              valueAvailable = newValue as bool;
                            } else {
                              valueAvailable = newValue as dynamic;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: double.infinity,
                    child: buttonField(
                        bgColor: ColorSelect.blueAccent,
                        borderColor: ColorSelect.blueAccent,
                        text: 'Filtern',
                        onPress: () async {
                          listOfTypes.then((value) => print(value.length));
                          await reloadList();
                          listOfTypes.then((value) => print(value.length));

                          newListOfCards = listOfTypes.then((value) {
                            return value
                                .where((element) =>
                                    element.storageId == valueStorage &&
                                    element.isAvailable == valueAvailable)
                                .toList();
                          });
                          onPressStorage(newListOfCards!);
                        },
                        textColor: Colors.white),
                  )
                ]));
          });
        });
  }
}
