import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/storage/add_storage_form.dart';

class AddStorage extends StatefulWidget {
  const AddStorage({Key? key}) : super(key: key);

  @override
  State<AddStorage> createState() => _AddStorageState();
}

class _AddStorageState extends State<AddStorage> {
  List<Storages> listOfStorages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await Data.checkAuthorization(
        context: context, function: fetchStorages);
    var temp = jsonDecode(response!.body) as List;
    listOfStorages = temp.map((e) => Storages.fromJson(e)).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SizerUtil.deviceType == DeviceType.mobile
            ? AppBar(
                toolbarHeight: 7.h,
                title: Text(
                  "Storage hinzufügen",
                  style: TextStyle(
                      color: Theme.of(context).focusColor, fontSize: 20.sp),
                ),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              )
            : AppBar(
                toolbarHeight: 8.h,
                title: Text(
                  "Storage hinzufügen",
                  style: TextStyle(
                      color: Theme.of(context).focusColor, fontSize: 18.sp),
                ),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              ),
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              BuildStorage(
                listOfStorages: listOfStorages,
              ),
            ],
          ),
        ));
  }
}

class BuildStorage extends StatefulWidget {
  final List<Storages> listOfStorages;

  const BuildStorage({
    Key? key,
    required this.listOfStorages,
  }) : super(key: key);

  @override
  State<BuildStorage> createState() => _BuildStorageState();
}

class _BuildStorageState extends State<BuildStorage> {
  List<Storages> listOfStorages = [];
  Storages storage = Storages(
    name: "",
    location: "",
    numberOfCards: 0,
    cards: [],
  );

  @override
  void initState() {
    super.initState();
  }

  void setStorageName(String value) {
    storage.name = value;
  }

  void setNumberOfCardsInStorage(String value) {
    storage.numberOfCards = int.parse(value);
  }

  void setStorageLocation(String value) {
    storage.location = value;
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final numCardsController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return Expanded(
        child: Column(
      children: [
        BuildAddStorageForm(
          context: context,
          formKey: formKey,
          nameController: nameController,
          locationController: locationController,
          numCardsController: numCardsController,
          setStorageName: setStorageName,
          setStorageLocation: setStorageLocation,
          setNumberOfCardsInStorage: setNumberOfCardsInStorage,
          listOfStorages: listOfStorages,
          storage: storage,
        )
      ],
    ));
  }
}
