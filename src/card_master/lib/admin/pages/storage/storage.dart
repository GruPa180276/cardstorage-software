import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/focus.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/pages/storage/storage_builder.dart';

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
  bool focusState = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    futureListOfStorages = fetchData();
  }

  Future<List<Storages>> fetchData() async {
    var response = await Data.checkAuthorization(
      context: context,
      function: getAllUnfocusedStorages,
    );
    var temp = jsonDecode(response!.body) as List;
    listOfUnfocusedStorages = temp.map((e) => FocusS.fromJson(e)).toList();

    for (int i = 0; i < listOfUnfocusedStorages.length; i++) {
      for (int j = 0; j < listOfStorages.length; j++) {
        if (listOfUnfocusedStorages[i].name == listOfStorages[j].name) {
          focusState = false;
        }
      }
    }

    if (context.mounted) {
      response = await Data.checkAuthorization(
        context: context,
        function: fetchStorages,
      );
      temp = jsonDecode(response!.body) as List;
      listOfStorages = temp.map((e) => Storages.fromJson(e)).toList();
    }

    setState(() {});

    return listOfStorages;
  }

  void search(String query) {
    if (query.isEmpty) {
      load();
      setState(() {});
      return;
    }

    query = query.toLowerCase();

    for (int i = 0; i < listOfStorages.length; i++) {
      var name = listOfStorages[i].name.toString().toLowerCase();
      if (name.contains(query)) {
        listOfFilteredStorages.add(listOfFilteredStorages[i]);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      floatingActionButton: GenerateReloadButton(load),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: txtQuery,
                            onChanged: search,
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  txtQuery.text = '';
                                  search(txtQuery.text);
                                },
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Column(children: [
                ListStorages(
                  listOfStorages: futureListOfStorages,
                  focusState: focusState,
                )
              ]),
            ),
          ])),
    );
  }
}
