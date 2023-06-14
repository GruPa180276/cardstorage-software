import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/config/palette.dart';
import 'package:card_master/client/pages/widgets/widget/default_custom_button.dart';
import 'package:card_master/client/provider/rest/types/readercard.dart';

class BottomSheetPop {
  String _valueStorage = '';
  dynamic _valueAvailable = 'alle';
  final Function(Future<List<ReaderCard>?>) setReaderCards;
  final Future<List<ReaderCard>?> defaultCards;
  late Future<List<ReaderCard>?> modifiedCards;

  BottomSheetPop({
    Key? key,
    required this.defaultCards,
    required this.setReaderCards,
  });

  Future buildBottomSheet(BuildContext context) async {
    List<String> listOfStorageId = await _getStorageNames();
    final listofAvailable = ['alle', true, false];
    listOfStorageId.insert(0, "alle");
    _valueStorage = listOfStorageId.first;
    // ignore: use_build_context_synchronously
    return showModalBottomSheet(
        isScrollControlled: true,
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
                height:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? MediaQuery.of(context).size.height / 3.5
                        : MediaQuery.of(context).size.width / 3.5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: Column(children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 30),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Storage',
                        style: TextStyle(fontSize: 2.0.fs),
                      )),
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          value: _valueStorage,
                          items: listOfStorageId.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem.toString()));
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
                        'Verfügbar',
                        style: TextStyle(fontSize: 2.0.fs),
                      )),
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          value: _valueAvailable,
                          items: listofAvailable.map((valueItem) {
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
                    child: DefaultCustomButton(
                        bgColor: ColorSelect.blueAccent,
                        borderColor: ColorSelect.blueAccent,
                        text: 'Filtern',
                        onPress: () {
                          //Improve logic readability
                          modifiedCards = defaultCards.then((value) {
                            if (_valueAvailable.toString() == "alle" &&
                                _valueStorage.toString() == "alle") {
                              return value;
                            } else if (_valueAvailable.toString() == "alle") {
                              return value!
                                  .where((element) =>
                                      element.storageName == _valueStorage)
                                  .toList();
                            } else if (_valueStorage.toString() == "alle") {
                              var x = value!
                                  .where((element) =>
                                      element.available == _valueAvailable)
                                  .toList();

                              return x;
                            }
                            return value!
                                .where((element) =>
                                    (element.storageName == _valueStorage &&
                                        element.available == _valueAvailable))
                                .toList();
                          });

                          setReaderCards(modifiedCards);
                        },
                        textColor: Colors.white),
                  )
                ]));
          });
        });
  }

  Future<List<String>> _getStorageNames() async {
    var readerCards = await defaultCards;
    Set<String> storagenames = <String>{};

    for (ReaderCard readerCard in readerCards!) {
      storagenames.add(readerCard.storageName!);
    }
    return storagenames.toList();
  }
}
