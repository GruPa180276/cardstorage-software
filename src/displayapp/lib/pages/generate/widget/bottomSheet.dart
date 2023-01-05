import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class BottomSheetPop {
  String _valueStorage = '';
  dynamic _valueAvailable = 'alle';
  final Function( Future<Storage?>) onPressStorage;
  Future<Storage?> listOfTypes;
   Future<Storage?>? newListOfCards;

  BottomSheetPop({
    Key? key,
    required this.listOfTypes,
    required this.onPressStorage,
  });

  Future buildBottomSheet(BuildContext context) async {
    final _listofAvailable = ['alle', true, false];

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
                          newListOfCards = listOfTypes.then((value) {
                            if (_valueAvailable.toString()!="alle" ) {
                                  return Storage(name: value!.name, location: value.location, address: value.address, capacity: value.capacity,cards: value.cards?.where((element) => element.available==_valueAvailable).toList());
                            } 
                            else if (_valueAvailable.toString()=="alle") {
                              return value;   
                            } 
                          
                          }) ;
                          onPressStorage(newListOfCards!);
                        },
                        textColor: Colors.white),
                  )
                ]));
          });
        });
  }
}