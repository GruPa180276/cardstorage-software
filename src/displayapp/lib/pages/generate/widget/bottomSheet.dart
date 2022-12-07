import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/provider/types/cards.dart';

class BottomSheetPop {
  dynamic valueStorage = '-';
  dynamic valueAvailable = '-';
  List<dynamic> listOfStorageId = ['-', 1117, 1118];
  List<dynamic> listofAvailable = ['-', true, false];
  final Function(Future<List<Cards>>) onPressStorage;
  Future<List<Cards>> listOfTypes;
  Future<List<Cards>>? newListOfCards;

  BottomSheetPop({
    Key? key,
    required this.listOfTypes,
    required this.onPressStorage,
  });

  Future buildBottomSheet(BuildContext context) {
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
                      SizedBox(
                        width: 60,
                        child: DropdownButton(
                          isExpanded: true,
                          value: valueStorage,
                          items: listOfStorageId.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem.toString()));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue != '-') {
                                valueStorage = newValue as int;
                              } else {
                                valueStorage = newValue as dynamic;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
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
                            if (newValue != '-') {
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
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: double.infinity,
                    height: 50,
                    child: buttonField(
                        bgColor: ColorSelect.blueAccent,
                        borderColor: ColorSelect.blueAccent,
                        text: 'Filtern',
                        onPress: () {
                          // listOfTypes.then((value) => print(value.length));
                          // // ignore: avoid_print
                          // listOfTypes.then((value) => print(value.length));
                          // //Improve logic readability
                          // newListOfCards = listOfTypes.then((value) {
                          //   if (valueAvailable.toString().startsWith("-") &&
                          //       valueStorage.toString().startsWith("-")) {
                          //     return value;
                          //   } else if (valueAvailable
                          //       .toString()
                          //       .startsWith("-")) {
                          //     return value
                          //         .where((element) =>
                          //             element.storageId == valueStorage)
                          //         .toList();
                          //   } else if (valueStorage
                          //       .toString()
                          //       .startsWith("-")) {
                          //     return value
                          //         .where((element) =>
                          //             element.isAvailable == valueAvailable)
                          //         .toList();
                          //   }
                          //   return value
                          //       .where((element) =>
                          //           element.storageId == valueStorage &&
                          //           element.isAvailable == valueAvailable)
                          //       .toList();
                          // });
                          // onPressStorage(newListOfCards!);
                        },
                        textColor: Colors.white),
                  )
                ]));
          });
        });
  }
}
