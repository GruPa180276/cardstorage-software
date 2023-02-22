import 'package:flutter/material.dart';

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
  }) : super(key: key);

  @override
  State<BuildAlterStorageForm> createState() => _BuildAlterStorageFormState();
}

class _BuildAlterStorageFormState extends State<BuildAlterStorageForm> {
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
        generateButtonRectangle(context, "Storage aktualisiern", () async {
          if (widget.formKey.currentState!.validate()) {
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

            await Data.checkAuthorization(
                function: deleteStorage,
                context: context,
                args: {
                  "name": widget.oldStorageName,
                });

            if (context.mounted) {
              await Data.checkAuthorization(
                  function: deleteUser,
                  context: context,
                  args: {
                    "name":
                        "${widget.oldStorageName.toLowerCase()}@default.com",
                  });
            }

            if (context.mounted) {
              await Data.checkAuthorization(
                  context: context,
                  function: addStorage,
                  args: {"name": "", 'data': newEntry.toJson()});
            }

            if (context.mounted) {
              await Data.checkAuthorization(
                  context: context,
                  function: addUser,
                  args: {"name": "", 'data': newUser.toJson()});
            }

            if (context.mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          }
        }),
      ]),
    ));
  }
}
