import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/pages/status/status_builder.dart';

class StatusView extends StatefulWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  late Future<List<Storages>> futureListOfStorages;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    futureListOfStorages = fetchData();
  }

  Future<List<Storages>> fetchData() async {
    final response = await Data.checkAuthorization(
      context: context,
      function: fetchStorages,
    );

    List jsonResponse = json.decode(response!.body);
    return jsonResponse.map((data) => Storages.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generateAppBar(context),
        floatingActionButton: GenerateReloadButton(callBack: load),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            Expanded(
              child: Column(children: [
                ListStatus(
                  listOfStorages: futureListOfStorages,
                )
              ]),
            ),
          ]),
        ));
  }
}
