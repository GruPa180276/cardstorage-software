import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/provider/types/card_reservation.dart';
import 'package:card_master/admin/pages/widget/forms/alter_storage_form.dart';

class StorageSettings extends StatefulWidget {
  final String storageName;

  const StorageSettings({
    Key? key,
    required this.storageName,
  }) : super(key: key);

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  List<Storages> listOfStorages = [];
  List<CardReservation> listOfCardReservations = [];

  Storages storage = Storages(
    name: "",
    location: "",
    numberOfCards: 0,
    cards: [],
  );

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var respons = await Data.checkAuthorization(
        context: context, function: fetchReservations);
    var tem = jsonDecode(respons!.body) as List;
    listOfCardReservations =
        tem.map((e) => CardReservation.fromJson(e)).toList();

    if (context.mounted) {
      var response = await Data.checkAuthorization(
          context: context, function: fetchStorages);
      var temp = jsonDecode(response!.body) as List;
      listOfStorages = temp.map((e) => Storages.fromJson(e)).toList();
    }

    for (int i = 0; i < listOfStorages.length; i++) {
      if (listOfStorages[i].name == widget.storageName) {
        storage = listOfStorages[i];
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SizerUtil.deviceType == DeviceType.mobile
            ? AppBar(
                toolbarHeight: 7.h,
                title: Text(
                  "Storage bearbeiten",
                  style: TextStyle(
                      color: Theme.of(context).focusColor, fontSize: 20.sp),
                ),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              )
            : AppBar(
                toolbarHeight: 8.h,
                title: Text(
                  "Storage bearbeiten",
                  style: TextStyle(
                      color: Theme.of(context).focusColor, fontSize: 18.sp),
                ),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              ),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(children: [
                    BuildUpdateStorage(
                      oldStorageName: widget.storageName,
                      storage: storage,
                      listOfStorages: listOfStorages,
                      listOfCardReservations: listOfCardReservations,
                    )
                  ])),
            )
          ]),
        ));
  }
}

class BuildUpdateStorage extends StatefulWidget {
  final List<Storages> listOfStorages;
  final String oldStorageName;
  final Storages storage;
  final List<CardReservation> listOfCardReservations;

  const BuildUpdateStorage({
    Key? key,
    required this.listOfStorages,
    required this.oldStorageName,
    required this.storage,
    required this.listOfCardReservations,
  }) : super(key: key);

  @override
  State<BuildUpdateStorage> createState() => _BuildUpdateStorageState();
}

class _BuildUpdateStorageState extends State<BuildUpdateStorage> {
  @override
  void initState() {
    super.initState();
  }

  void setStorageName(String value) {
    widget.storage.name = value;
  }

  void setNumberOfCardsInStorage(String value) {
    widget.storage.numberOfCards = int.parse(value);
  }

  void setStorageLocation(String value) {
    widget.storage.location = value;
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: widget.storage.name);
    final locationController =
        TextEditingController(text: widget.storage.location);
    final numCardsController =
        TextEditingController(text: widget.storage.numberOfCards.toString());

    final formKey = GlobalKey<FormState>();

    return Expanded(
        child: Column(
      children: [
        BuildAlterStorageForm(
            context: context,
            formKey: formKey,
            nameController: nameController,
            locationController: locationController,
            numCardsController: numCardsController,
            setStorageName: setStorageName,
            setStorageLocation: setStorageLocation,
            setNumberOfCardsInStorage: setNumberOfCardsInStorage,
            listOfStorages: widget.listOfStorages,
            storage: widget.storage,
            oldStorageName: widget.oldStorageName,
            listOfCardReservations: widget.listOfCardReservations)
      ],
    ));
  }
}
