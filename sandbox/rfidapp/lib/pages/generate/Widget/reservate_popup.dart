import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/Widget/date_picker.dart';

Widget buildTimeChooseSection(BuildContext context, String text,
    TextEditingController editingController) {
  return Row(children: [
    SizedBox(
      width: 40,
      child: Text(text),
    ),
    // SizedBox(
    //   width: 15,
    // ),
    SizedBox(
      height: 40,
      width: 200,
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: TextField(
              controller: editingController,
              readOnly: true,
              decoration: const InputDecoration(
                prefixText: 'prefix',
                prefixStyle: TextStyle(color: Colors.transparent),
              ),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () {
                buildDateTimePicker(text, editingController, context);
              }),
        ],
      ),
    )
  ]);
}
