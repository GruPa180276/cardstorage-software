import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enum/readercard_type.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/reservation.dart';
import 'package:rfidapp/provider/types/storage.dart';

class BottomSheetPop {
  String _valueCard = 'alle';
  dynamic _valueAvailable = 'alle';
  final Function(Future<Storage?>) onPressStorage;
  Future<Storage?> defaultStorage;
  Future<Storage?>? _modifiedStorage;
  List<String> _dropDownCardValues = ['alle'];
  final _dropDownAvailable = ['alle', true, false];
  final _dropDownReservationType = ['alle', "Reservierung", "In Benutzung"];

  CardPageType cardPageType;
  BottomSheetPop(
      {Key? key,
      required this.defaultStorage,
      required this.onPressStorage,
      required this.cardPageType});

  Future buildBottomSheet(BuildContext context) async {
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
                      const Expanded(
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
                            return null;
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
                      const Expanded(
                          child: Text(
                        'Karten',
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
                  Row(
                    children: [
                      const Expanded(
                          child: Text(
                        'Verfuegabar',
                        style: TextStyle(fontSize: 17),
                      )),
                      Expanded(
                        child: DropdownButton(
                          value: _valueAvailable,
                          items: _dropDownReservationType.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem.toString()));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue != 'alle') {
                                _valueAvailable = newValue as String;
                              } else {
                                _valueAvailable = newValue as String;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                            if (_dropDownReservationType.toString() == "alle" &&
                                _valueCard.toString() == "alle") {
                              return value;
                            } else if (_dropDownReservationType.toString() ==
                                "alle") {
                              return Storage(
                                  name: value!.name,
                                  location: value.location,
                                  address: value.address,
                                  capacity: value.capacity,
                                  cards: value.cards
                                      ?.where((element) =>
                                          (element.name == _valueCard))
                                      .toList());
                            } else if (_valueCard.toString() == "alle") {
                              return Storage(
                                  name: value!.name,
                                  location: value.location,
                                  address: value.address,
                                  capacity: value.capacity,
                                  cards: getFilteredReservations(value));
                            }
                            return Storage(
                                name: value!.name,
                                location: value.location,
                                address: value.address,
                                capacity: value.capacity,
                                cards: getFilteredReservations(value)
                                    .where(
                                        (element) => element.name == _valueCard)
                                    .toList());
                            ;
                          });
                          onPressStorage(_modifiedStorage!);
                        },
                        textColor: Colors.white),
                  )
                ]));
          });
        });
  }

  List<ReaderCard> getFilteredReservations(Storage value) {
    List<ReaderCard> sortedCards = List.empty(growable: true);
    for (var karten in value!.cards!) {
      var card = new ReaderCard(
        reader: karten.reader,
        name: karten.name,
        position: karten.position,
        accessed: karten.accessed,
        available: karten.available,
        reservation: List<Reservation>.empty(growable: true),
      );
      for (var element in karten.reservation!) {
        if (element.isreservation == (_valueAvailable == "In Benutzung")
            ? false
            : true) {
          card.reservation!.add(element);
          sortedCards.add(card);
        }
      }
    }
    return sortedCards;
  }
}
