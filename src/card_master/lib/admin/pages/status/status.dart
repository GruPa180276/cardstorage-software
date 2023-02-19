import 'dart:convert';

import 'package:card_master/admin/pages/status/statusInkwell.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/circularprogressindicator.dart';

class StatusView extends StatefulWidget {
  StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  late Future<List<Storages>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
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
        floatingActionButton: GenerateReloadButton(fetchData),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Expanded(
                child: FutureBuilder<List<Storages>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Storages>? data = snapshot.data;
                  return ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GenerateStatus(
                          index: index,
                          data: data!,
                          icon: Icons.storage,
                          route: "/status",
                          argument: data[index].name,
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Container(
                    child: Column(
                  children: [
                    Center(child: generateProgressIndicator(context)),
                  ],
                ));
              },
            ))
          ]),
        ));
  }
}
