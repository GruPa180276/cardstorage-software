import 'package:card_master/admin/pages/card/search.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/focus.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/pages/storage/storage_builder.dart';
import 'package:sizer/sizer.dart';

class StorageView extends StatefulWidget {
  const StorageView({Key? key}) : super(key: key);

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  TextEditingController txtQuery = TextEditingController();
  late Future<List<Storages>> futureListOfStorages;
  List<Storages> listOfFilteredStorages = [];
  List<FocusS> listOfUnfocusedStorages = [];
  List<Storages> listOfStorages = [];

  @override
  void initState() {
    super.initState();
    load();
    doSearch("-");
  }

  void load() {
    futureListOfStorages = fetchData();
    doSearch("-");
  }

  Future<List<Storages>> fetchData() async {
    var response = await Data.checkAuthorization(
      context: context,
      function: getAllUnfocusedStorages,
    );
    var temp = jsonDecode(response!.body) as List;
    listOfUnfocusedStorages = temp.map((e) => FocusS.fromJson(e)).toList();

    if (context.mounted) {
      var response = await Data.checkAuthorization(
        context: context,
        function: fetchStorages,
      );
      var temp = jsonDecode(response!.body) as List;
      listOfStorages = temp.map((e) => Storages.fromJson(e)).toList();
    }

    listOfFilteredStorages = listOfStorages;

    setState(() {});

    return listOfStorages;
  }

  void doSearch(String query) {
    futureListOfStorages = search(query);
  }

  Future<List<Storages>> search(String query) async {
    if (query.isEmpty) {
      load();
      setState(() {});
      return futureListOfStorages;
    }

    if (query == "-") {
      return futureListOfStorages;
    }

    query = query.toLowerCase();

    List<Storages> tmp = [];

    for (int i = 0; i < listOfFilteredStorages.length; i++) {
      var name = listOfFilteredStorages[i].name.toString().toLowerCase();
      if (name.contains(query)) {
        tmp.add(listOfFilteredStorages[i]);
      }
    }

    setState(() {});

    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      floatingActionButton: GenerateReloadButton(
        callBack: load,
      ),
      body: Container(
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          generateButtonRound(
                              context, "Hinzufügen", Icons.add, "/addStorage"),
                        ],
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: buildSeacrh(context, txtQuery, doSearch)),
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Column(children: [
                ListStorages(
                  listOfStorages: futureListOfStorages,
                  listOfUnfocusedStorages: listOfUnfocusedStorages,
                )
              ]),
            ),
          ])),
    );
  }
}
