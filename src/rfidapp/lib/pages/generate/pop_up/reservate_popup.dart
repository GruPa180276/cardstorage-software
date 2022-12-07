import 'package:flutter/material.dart';
import 'package:rfidapp/domain/local_notification.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/widget/date_picker.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/cards.dart';

TextEditingController vonTextEdidtingcontroller = TextEditingController();
TextEditingController bisTextEdidtingcontroller = TextEditingController();
LocalNotificationService? service;

final _formKey = GlobalKey<FormState>();
Future<void> buildReservatePopUp(BuildContext context, Cards card) async {
  service = LocalNotificationService();
  service!.intialize();
  listenToNotification();

  vonTextEdidtingcontroller.clear;
  bisTextEdidtingcontroller.clear;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reservierung'),
          actionsPadding: const EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          actions: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTimeChooseField(
                    context,
                    "Von:",
                    vonTextEdidtingcontroller,
                  ),
                  const SizedBox(height: 20),
                  buildTimeChooseField(
                      context, "Bis:", bisTextEdidtingcontroller),
                  const SizedBox(height: 20),
                  buildReservateNow(context, card),
                ],
              ),
            )
          ],
        );
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
            child: TextFormField(
              validator: (value) {
                if (text == "Bis:" && bisTextEdidtingcontroller.text.isEmpty) {
                  return 'Bitte datum angeben';
                } else if (text == "Von:" &&
                    vonTextEdidtingcontroller.text.isEmpty) {
                  return 'Bitte datum angeben';
                } else if ((text == "Bis:" &&
                        !Validator.validateDates(vonTextEdidtingcontroller.text,
                            bisTextEdidtingcontroller.text)) &&
                    vonTextEdidtingcontroller.text.isNotEmpty) {
                  return 'Uhrzeit muss spaeter sein ';
                } else if (vonTextEdidtingcontroller.text.isNotEmpty &&
                    bisTextEdidtingcontroller.text.isNotEmpty &&
                    Validator.daysBetween(
                            DateTime.parse(vonTextEdidtingcontroller.text),
                            DateTime.parse(bisTextEdidtingcontroller.text)) >=
                        6) {
                  return 'Nicht laenger als 6h ';
                }
              },
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
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (DateTime.parse(vonTextEdidtingcontroller.text)
              .isBefore(DateTime.now())) {
            Navigator.pop(context);
          } else {
            // card.reservedSince = DateTime.parse(vonTextEdidtingcontroller.text)
            //     .millisecondsSinceEpoch;
            // card.reservedUntil = DateTime.parse(bisTextEdidtingcontroller.text)
            //     .millisecondsSinceEpoch;
            // Data.putData('card', card.toJson());
            // vonTextEdidtingcontroller.clear();
            // bisTextEdidtingcontroller.clear();
            // await service!.showScheduledNotification(
            //     id: card.id,
            //     title: 'Karte abholen${card.id}',
            //     body: 'Bitte holen Sie sich Ihre Karte ab',
            //     dateTime:
            //         DateTime.fromMillisecondsSinceEpoch(card.reservedSince!));
            // Navigator.pop(context);
          }
        }
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

void listenToNotification() =>
    service!.onNotificationClick.stream.listen(onNoticationListener);

void onNoticationListener(String? payload) {
  if (payload != null && payload.isNotEmpty) {}
}
