// ignore_for_file: constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rfidapp/domain/local_notification.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/widget/date_picker.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/rest/types/readercard.dart';
import 'package:rfidapp/provider/rest/types/reservation.dart';

class ReservationPopUp {
  TextEditingController vonTextEdidtingcontroller = TextEditingController();
  TextEditingController bisTextEdidtingcontroller = TextEditingController();
  LocalNotificationService? service;
  final _formKey = GlobalKey<FormState>();
  final BuildContext context;
  final ReaderCard card;
  late List<Reservation> reservations;
  ReservationPopUp(this.context, this.card);

  Future<void> build() async {
    await LocalNotificationService.intialize();
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
                      _TimeChooseFieldType.Von,
                      vonTextEdidtingcontroller,
                    ),
                    const SizedBox(height: 20),
                    buildTimeChooseField(context, _TimeChooseFieldType.Bis,
                        bisTextEdidtingcontroller),
                    const SizedBox(height: 20),
                    buildConfirmReservation(context, card),
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget buildTimeChooseField(
      BuildContext context,
      _TimeChooseFieldType timeChooseFieldType,
      TextEditingController editingController) {
    return Row(children: [
      SizedBox(
        width: 40,
        child: Text(
          "${timeChooseFieldType.toString().replaceAll("_TimeChooseFieldType.", "")}:",
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
                  if (vonTextEdidtingcontroller.text.isEmpty) {
                    return 'Bitte Datum angeben';
                  } else if (bisTextEdidtingcontroller.text.isEmpty) {
                    return 'Bitte Datum angeben';
                  } else if ((timeChooseFieldType == _TimeChooseFieldType.Bis &&
                          !Validator.validateDates(
                              vonTextEdidtingcontroller.text,
                              bisTextEdidtingcontroller.text) ||
                      DateTime.parse(editingController.text)
                          .isBefore(DateTime.now()))) {
                    return 'Uhrzeit muss später sein ';
                  } else if (vonTextEdidtingcontroller.text.isNotEmpty &&
                      bisTextEdidtingcontroller.text.isNotEmpty &&
                      Validator.daysBetween(
                              DateTime.parse(vonTextEdidtingcontroller.text),
                              DateTime.parse(bisTextEdidtingcontroller.text)) >=
                          6) {
                    return 'Nicht länger als 6h ';
                  } else {
                    var from = DateTime.parse(vonTextEdidtingcontroller.text)
                            .millisecondsSinceEpoch /
                        1000;
                    var till = DateTime.parse(bisTextEdidtingcontroller.text)
                            .millisecondsSinceEpoch /
                        1000;

                    for (var element in reservations) {
                      if (!((till > element.until || till < element.since) &&
                          (from < element.since || from > element.until))) {
                        return (timeChooseFieldType == _TimeChooseFieldType.Bis)
                            ? "Bereits Reservierung: ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(element.until * 1000))}"
                            : "Bereits Reservierung:: ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(element.since * 1000))}";
                      }
                    }
                  }
                  return null;
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
                    buildDateTimePicker(editingController, context))
          ],
        ),
      )
    ]);
  }

  Widget buildConfirmReservation(BuildContext context, ReaderCard card) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ))),
        onPressed: () async {
          var reservationsResponse = await Data.check(
              Data.getReservationsOfCard, {"cardname": card.name});

          var jsonReservation = jsonDecode(reservationsResponse.body) as List;
          reservations = jsonReservation
              .map((tagJson) => Reservation.fromJson(tagJson))
              .toList();

          if (_formKey.currentState!.validate()) {
            var response = await Data.newReservation({
              "cardname": card.name,
              "since": (DateTime.parse(vonTextEdidtingcontroller.text)
                      .millisecondsSinceEpoch ~/
                  1000),
              "until": (DateTime.parse(bisTextEdidtingcontroller.text)
                      .millisecondsSinceEpoch ~/
                  1000)
            });

            if (response.statusCode == 200) {
              await LocalNotificationService.showScheduledNotification(
                  dateTime: DateTime.parse(vonTextEdidtingcontroller.text),
                  id: DateTime.parse(vonTextEdidtingcontroller.text)
                          .millisecondsSinceEpoch ~/
                      1000,
                  title: 'Reservierung',
                  body: 'Reservierung ${card.name}');
              var snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Reservierung abgeschlossen!',
                    message: '',
                    contentType: ContentType.success,
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            } else {
              var snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Etwas ist schiefgelaufen!',
                    message: response.statusCode.toString(),
                    contentType: ContentType.failure,
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      LocalNotificationService.onNotificationClick.stream
          .listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {}
  }
}

enum _TimeChooseFieldType { Von, Bis }
