import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/Widget/date_picker.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/cards.dart';

TextEditingController vonTextEdidtingcontroller = TextEditingController();
TextEditingController bisTextEdidtingcontroller = TextEditingController();

Future<void> buildReservatePopUp(BuildContext context, Cards card) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Reservierung'),
            actionsPadding: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: [
              Column(
                children: [
                  buildTimeChooseField(
                      context, "Von:", vonTextEdidtingcontroller),
                  const SizedBox(height: 20),
                  buildTimeChooseField(
                      context, "Bis:", bisTextEdidtingcontroller),
                  const SizedBox(height: 20),
                  buildReservateNow(context, card),
                ],
              )
            ]);
      });
}

Widget buildTimeChooseField(BuildContext context, String text,
    TextEditingController editingController) {
  return Row(children: [
    SizedBox(
      width: 40,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
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
              onPressed: () =>
                  buildDateTimePicker(text, editingController, context))
        ],
      ),
    )
  ]);
}

Widget buildReservateNow(BuildContext context, Cards card) {
  return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ))),
      // ignore: avoid_print
      onPressed: () {
        card.reservedSince = DateTime.parse(vonTextEdidtingcontroller.text)
            .millisecondsSinceEpoch;
        card.reservedUntil = DateTime.parse(bisTextEdidtingcontroller.text)
            .millisecondsSinceEpoch;

        Data.putData('card', card.toJson());
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15),
        child: Text(
          'Jetzt Reservieren',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ));
}
