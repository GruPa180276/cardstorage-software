import 'dart:convert';
import 'dart:io';

import 'package:card_master/admin/provider/middelware.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:card_master/admin/pages/card/form.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/types/focus.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/pages/card/timer_dialog.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/card/alert_dialog.dart';
import 'package:card_master/admin/pages/card/storage_selector.dart';
import 'package:web_socket_channel/io.dart';

import '../../../client/domain/types/snackbar_type.dart';
import '../../../client/pages/widgets/pop_up/response_snackbar.dart';

class AddCards extends StatefulWidget {
  const AddCards({Key? key}) : super(key: key);

  @override
  State<AddCards> createState() => _AddCardsState();
}

class _AddCardsState extends State<AddCards> {
  List<String> listOfStorageNames = [];
  List<Storages> listOfStorages = [];
  List<Cards> listOfCards = [];
  List<FocusS> listUnfocusedStorages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await fetchCards().then((value) => listOfCards = value);
    // await fetchStorages().then((value) => listOfStorages = value);
    await getAllUnfocusedStorages()
        .then((value) => listUnfocusedStorages = value);

    listOfStorageNames.add("-");
    for (int i = 0; i < listOfStorages.length; i++) {
      listOfStorageNames.add(listOfStorages[i].name);
    }

    for (int i = 0; i < listOfStorageNames.length; i++) {
      for (int j = 0; j < listUnfocusedStorages.length; j++) {
        if (listOfStorageNames[i] == listUnfocusedStorages[j].name) {
          listOfStorageNames.removeAt(i);
          setState(() {});
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Karte hinzufügen",
          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Column(
        children: [
          GenerateCards(
            listOfCards: listOfCards,
            listOfStorageNames: listOfStorageNames,
            listOfStorages: listOfStorages,
          )
        ],
      ),
    );
  }
}

class GenerateCards extends StatefulWidget {
  final List<String> listOfStorageNames;
  final List<Storages> listOfStorages;
  final List<Cards> listOfCards;

  const GenerateCards({
    Key? key,
    required this.listOfStorageNames,
    required this.listOfCards,
    required this.listOfStorages,
  }) : super(key: key);

  @override
  State<GenerateCards> createState() => _GenerateCardsState();
}

class _GenerateCardsState extends State<GenerateCards> {
  String selectedStorage = "-";
  Cards card = Cards(
    name: "",
    storage: "",
    position: 0,
    accessed: 0,
    available: false,
    reader: "",
  );

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void setCardName(String value) {
    card.name = value;
  }

  void setSelectedStorage(String value) {
    setState(() {
      selectedStorage = value;
    });
    Navigator.of(context).pop();
  }

  IOWebSocketChannel? channel;
  Map? _responseData;
  bool? _successful;

  void connectSocket() async {
    channel = IOWebSocketChannel.connect(
        Uri.parse('wss://10.0.2.2:7171/api/v1/storages/cards/log'),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${Data.bearerToken}",
        });
    _streamListener();
  }

  _streamListener() {
    channel!.stream.listen((message) async {
      _responseData = jsonDecode(message);
      _successful = _responseData!["successful"] ??
          _responseData!["status"]["successful"];
      channel!.sink.close();
      if (_successful!) {
        SnackbarBuilder(
                context: context,
                snackbarType: SnackbarType.success,
                header: "Karte wird heruntergelassen!",
                content: null)
            .build();
      } else {
        SnackbarBuilder(
                context: context,
                snackbarType: SnackbarType.failure,
                header: "Verbindungsfehler!",
                content: _responseData)
            .build();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: card.name);
    final formKey = GlobalKey<FormState>();

    return Expanded(
      child: Column(
        children: [
          buildCardForm(context, "Karte hinzufügen", (() async {
            if (formKey.currentState!.validate() && selectedStorage != "-") {
              Cards newEntry = Cards(
                name: card.name,
                storage: selectedStorage,
                position: card.position,
                accessed: card.accessed,
                available: card.available,
                reader: "",
              );

              Future<int> code = addCard(newEntry.toJson());

              if (await code == 200) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        buildTimerdialog(context, newEntry));
              }
              if (await code == 400) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => buildAlertDialog(
                          context,
                          "Karte hinzufügen ...",
                          "Es ist ein Fehler beim anlegen der Karte aufgetreten!",
                          [
                            generateButtonRectangle(
                              context,
                              "Ok",
                              () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ));
              }
            }
          }),
              formKey,
              GenerateListTile(
                labelText: "Name",
                hintText: "",
                icon: Icons.storage,
                regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
                function: setCardName,
                controller: nameController,
                fun: (value) {
                  for (int i = 0; i < widget.listOfCards.length; i++) {
                    if (widget.listOfCards[i].name == value) {
                      return 'Exsistiert bereits!';
                    }
                  }
                  if (value!.isEmpty) {
                    return 'Bitte Name eingeben!';
                  } else {
                    return null;
                  }
                },
              ),
              buildStorageSelector(
                context,
                selectedStorage,
                widget.listOfStorageNames,
                setSelectedStorage,
                "Selected Storage",
              ))
        ],
      ),
    );
  }
}
