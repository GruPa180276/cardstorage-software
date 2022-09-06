import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';

class BottomSheetPop {
  const BottomSheetPop(
      {Key? key, required this.onPressStorage, required this.listOfTypes});
  final Function(Future<List<Cards>>) onPressStorage;
  final Future<List<Cards>> listOfTypes;

  Future buildBottomSheet(BuildContext context) {
    //TODO getStorageIds by API
    String valueStorage = '';
    String valueAvail = '';
    List<int> storageId = [1117, 1118];
    List<bool> availAble = [true, false];

    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (context) => Container(
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
                    items: storageId.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem.toString()));
                    }).toList(),
                    onChanged: (valueIt) {
                      onPressStorage(listOfTypes.then((value) {
                        return value
                            .where((element) => element.storageId == valueIt)
                            .toList();
                      }));
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
                    items: availAble.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem.toString()));
                    }).toList(),
                    onChanged: (valueIt) {
                      onPressStorage(listOfTypes.then((value) {
                        return value
                            .where((element) => element.isAvailable == valueIt)
                            .toList();
                      }));
                    },
                  ),
                ],
              )
            ])));
  }
}
