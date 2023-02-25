import 'package:card_master/admin/provider/types/cardReservation.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/provider/types/reservations.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/provider/types/storages.dart';

class BuildAlterStorageForm extends StatefulWidget {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController locationController;
  final TextEditingController numCardsController;
  final Function setStorageName;
  final Function setStorageLocation;
  final Function setNumberOfCardsInStorage;
  final List<Storages> listOfStorages;
  final Storages storage;
  final String oldStorageName;
  final List<CardReservation> listOfCardReservations;

  const BuildAlterStorageForm({
    Key? key,
    required this.context,
    required this.formKey,
    required this.nameController,
    required this.locationController,
    required this.numCardsController,
    required this.setStorageName,
    required this.setStorageLocation,
    required this.setNumberOfCardsInStorage,
    required this.listOfStorages,
    required this.storage,
    required this.oldStorageName,
    required this.listOfCardReservations,
  }) : super(key: key);

  @override
  State<BuildAlterStorageForm> createState() => _BuildAlterStorageFormState();
}

class _BuildAlterStorageFormState extends State<BuildAlterStorageForm> {
  Response? response1;
  Response? response2;
  Response? response3;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Form(
      key: widget.formKey,
      child: Column(children: [
        GenerateListTile(
          labelText: "Name",
          hintText: "",
          icon: Icons.storage,
          regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
          function: widget.setStorageName,
          controller: widget.nameController,
          fun: (value) {
            for (int i = 0; i < widget.listOfStorages.length; i++) {
              if (widget.listOfStorages[i].name == widget.oldStorageName) {
                return null;
              } else if (value!.isEmpty) {
                return 'Bitte Name eingeben!';
              } else if (widget.listOfStorages[i].name == value) {
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
        const SizedBox(
          height: 10,
        ),
        GenerateListTile(
          labelText: "Standort",
          hintText: "",
          icon: Icons.location_city,
          regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
          function: widget.setStorageLocation,
          controller: widget.locationController,
          fun: (value) {
            if (value!.isEmpty) {
              return 'Bitte Location eingeben!';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        GenerateListTile(
          labelText: "Anzahl an Karten",
          hintText: "",
          icon: Icons.format_list_numbered,
          regExp: r'([0-9])',
          function: widget.setNumberOfCardsInStorage,
          controller: widget.numCardsController,
          fun: (value) {
            if (value!.isEmpty) {
              return 'Bitte Anzahl eingeben!';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        generateButtonRectangle(context, "Storage aktualisieren", () async {
          if (widget.formKey.currentState!.validate() &&
              widget.storage.cards.isEmpty) {
            Storages newEntry = Storages(
              name: widget.storage.name,
              location: widget.storage.location,
              numberOfCards: widget.storage.numberOfCards,
              cards: widget.storage.cards,
            );

            Users newUser = Users(
              email: "${newEntry.name.toLowerCase()}@default.com",
              storage: widget.storage.name,
              privileged: false,
            );

            if (context.mounted) {
              response1 = await Data.checkAuthorization(
                  function: deleteStorage,
                  context: context,
                  args: {
                    "name": widget.oldStorageName,
                  });
            }

            if (context.mounted) {
              response2 = await Data.checkAuthorization(
                  function: deleteUser,
                  context: context,
                  args: {
                    "name":
                        "${widget.oldStorageName.toLowerCase()}@default.com",
                  });
            }

            if (context.mounted) {
              response3 = await Data.checkAuthorization(
                  context: context,
                  function: addStorage,
                  args: {"name": "", 'data': newEntry.toJson()});
            }

            if (context.mounted) {
              Response? response4 = await Data.checkAuthorization(
                  context: context,
                  function: addUser,
                  args: {"name": "", 'data': newUser.toJson()});

              if (response1!.statusCode == 200 &&
                  response2!.statusCode == 200 &&
                  response3!.statusCode == 200 &&
                  response4!.statusCode == 200 &&
                  context.mounted) {
                FeedbackBuilder(
                  context: context,
                  header: "Erfolgreich",
                  snackbarType: FeedbackType.success,
                  content: "Storage wurde bearbeitet!",
                ).build();
              }
            }

            if (context.mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          } else if (widget.storage.cards.isNotEmpty) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            FeedbackBuilder(
              context: context,
              header: "Error!",
              snackbarType: FeedbackType.failure,
              content: "Bitte alle Karten löschen!",
            ).build();
          }
        }),
      ]),
    ));
  }
}
