import 'package:flutter/material.dart';

Widget buildStorageSelector(
  BuildContext context,
  String selectedStorage,
  List<String> dropDownValues,
  Function(String) setSelectedStorage,
  String selectorText,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
        minimumSize: const Size(0, 60)),
    child: Wrap(
      children: <Widget>[
        const Icon(
          Icons.filter_list,
        ),
        const SizedBox(
          width: 10,
        ),
        Text("$selectorText: $selectedStorage",
            style: const TextStyle(fontSize: 20)),
      ],
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Select Storage"),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                value: selectedStorage,
                items: dropDownValues.map((valueItem) {
                  return DropdownMenuItem(
                      value: valueItem, child: Text(valueItem.toString()));
                }).toList(),
                onChanged: (String? newValue) {
                  setSelectedStorage(newValue!);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
