import 'package:flutter/material.dart';

import 'dart:async';

import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/widget/card.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/appbar.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: Changed the API Calls to the actual API

class StorageView extends StatefulWidget {
  StorageView({Key? key}) : super(key: key);

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generateAppBar(context),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: generateButtonRound(
                        context, "Hinzufügen", Icons.add, "/addStorage"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: generateButtonRound(
                        context, "Entfernen", Icons.remove, "/removeStorage"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(children: [ListCardStorages()])),
            )
          ]),
        ));
  }
}

class ListCardStorages extends StatefulWidget {
  const ListCardStorages({Key? key}) : super(key: key);

  @override
  State<ListCardStorages> createState() => _ListCardStoragesState();
}

class _ListCardStoragesState extends State<ListCardStorages> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                return GenerateCards.withArguments(
                    index: index,
                    data: data!,
                    icon: Icons.credit_card,
                    route: "/alterStorage",
                    argument: data[index].id - 1);
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
            child: Column(
          children: [
            generateProgressIndicator(context),
          ],
        ));
      },
    ));
  }
}
