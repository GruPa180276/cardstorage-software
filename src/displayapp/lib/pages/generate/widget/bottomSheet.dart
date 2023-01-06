import 'package:flutter/material.dart';
import 'package:rfidapp/config/cardSiteEnum.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class BottomSheetPop {
  String _valueCard = 'alle';
  dynamic _valueAvailable = 'alle';
  final Function(Future<Storage?>) onPressStorage;
  Future<Storage?> defaultStorage;
  Future<Storage?>? _modifiedStorage;
  List<String> _dropDownCardValues = ['alle'];
  final _dropDownAvailable = ['alle', true, false];

  CardPageType cardPageType;
  BottomSheetPop(
      {Key? key,
      required this.defaultStorage,
      required this.onPressStorage,
      required this.cardPageType});

  Future buildBottomSheet(BuildContext context) async {
    final _listofAvailable = ['alle', true, false];
    switch (cardPageType) {
      case CardPageType.Karten:
        return _buildCardPage(context);
      case CardPageType.Reservierungen:
        return _buildReservationPage(context);
    }
    //TODO getStorageIds by API
  }

  Future _buildCardPage(BuildContext context) {
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
                      Expanded(
                          child: Text(
                        'Verfuegabar',
                        style: TextStyle(fontSize: 17),
                      )),
                      Expanded(
                        child: DropdownButton(
                          value: _valueAvailable,
                          items: _dropDownAvailable.map((valueItem) {
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
                          _modifiedStorage = defaultStorage.then((value) {
                            if (_valueAvailable.toString() != "alle") {
                              return Storage(
                                  name: value!.name,
                                  location: value.location,
                                  address: value.address,
                                  capacity: value.capacity,
                                  cards: value.cards
                                      ?.where((element) =>
                                          element.available == _valueAvailable)
                                      .toList());
                            } else if (_valueAvailable.toString() == "alle") {
                              return value;
                            }
                          });
                          onPressStorage(_modifiedStorage!);
                        },
                        textColor: Colors.white),
                  )
                ]));
          });
        });
  }

  Future _buildReservationPage(BuildContext context) async {
    Storage? storage = await Data.getStorageData();
    for (var element in storage!.cards!) {
      if (element.reservation!.isNotEmpty) {
        _dropDownCardValues.add(element.name);
      }
    }

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
                      Expanded(
                          child: Text(
                        'Verfuegabar',
                        style: TextStyle(fontSize: 17),
                      )),
                      Expanded(
                        child: DropdownButton(
                          value: _valueCard,
                          items: _dropDownCardValues.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem.toString()));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue != 'alle') {
                                _valueCard = newValue as String;
                              } else {
                                _valueCard = newValue as dynamic;
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
                          _modifiedStorage = defaultStorage.then((value) {
                            if (_valueCard.toString() != "alle") {
                              return Storage(
                                  name: value!.name,
                                  location: value.location,
                                  address: value.address,
                                  capacity: value.capacity,
                                  cards: value.cards
                                      ?.where((element) =>
                                          element.name == _valueCard)
                                      .toList());
                            } else {
                              return value;
                            }
                          });
                          onPressStorage(_modifiedStorage!);
                        },
                        textColor: Colors.white),
                  )
                ]));
          });
        });
  }
}