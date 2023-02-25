import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:http/http.dart';

class BuildAddStorageForm extends StatefulWidget {
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

  const BuildAddStorageForm({
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
  }) : super(key: key);

  @override
  State<BuildAddStorageForm> createState() => _BuildAddStorageFormState();
}

class _BuildAddStorageFormState extends State<BuildAddStorageForm> {
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
                if (widget.listOfStorages[i].name == value) {
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
          generateButtonRectangle(
            context,
            "Storage hinzufügen",
            () async {
              if (widget.formKey.currentState!.validate()) {
                Storages newEntry = Storages(
                    name: widget.storage.name,
                    location: widget.storage.location,
                    numberOfCards: widget.storage.numberOfCards,
                    cards: []);

                Response? response1 = await Data.checkAuthorization(
                    context: context,
                    function: addStorage,
                    args: {"name": "", 'data': newEntry.toJson()});

                Users newUser = Users(
                  email: "${newEntry.name.toLowerCase()}@default.com",
                  storage: widget.storage.name,
                  privileged: false,
                );

                if (context.mounted) {
                  Response? response2 = await Data.checkAuthorization(
                      context: context,
                      function: addUser,
                      args: {"name": "", 'data': newUser.toJson()});

                  if (response1!.statusCode == 200 &&
                      response2!.statusCode == 200 &&
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
                }
              }
            },
          ),
        ]),
      ),
    );
  }
}
