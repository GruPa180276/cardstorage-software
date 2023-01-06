import 'package:admin_login/provider/types/ping.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/appbar.dart';
import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/pages/widget/cardwithinkwell.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

late Future<List<Storages>> futureData;

class StatusView extends StatefulWidget {
  StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generateAppBar(context),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            ListCardStorages(),
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
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Storages>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Storages>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                return GenerateCardWithInkWell.withArguments(
                  index: index,
                  data: data!,
                  icon: Icons.storage,
                  route: "/status",
                  argument: data[index].name,
                  view: 2,
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
    ));
  }
}
