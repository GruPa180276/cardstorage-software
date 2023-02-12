import 'package:flutter/material.dart';

Widget buildSeacrh(
  BuildContext context,
  TextEditingController txtQuery,
  Function(String) search,
) {
  return Expanded(
      child: TextFormField(
    controller: txtQuery,
    onChanged: search,
    decoration: InputDecoration(
      hintText: "Search",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          txtQuery.text = '';
          search(txtQuery.text);
        },
      ),
    ),
  ));
}
