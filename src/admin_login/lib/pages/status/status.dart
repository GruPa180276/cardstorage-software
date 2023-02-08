import 'package:admin_login/pages/status/statusInkwell.dart';
import 'package:admin_login/pages/widget/reloadbutton.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/appbar.dart';
import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

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

  void reload() {
    setState(() {
      futureData = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generateAppBar(context),
        floatingActionButton: GenerateReloadButton(this.reload),
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
