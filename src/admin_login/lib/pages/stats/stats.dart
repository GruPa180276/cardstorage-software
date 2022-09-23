import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/Widget/appbar.dart';
import 'package:admin_login/pages/widget/speeddial.dart';
import 'package:admin_login/pages/widget/cardwithinkwell.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: Changed the API Calls to the actual API

class StatsView extends StatefulWidget {
  StatsView({Key? key}) : super(key: key);

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  String selectedStorage = "1";

  @override
  void initState() {
    super.initState();
  }

  callBack(String storage) {
    setState(() {
      selectedStorage = storage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GenerateSpeedDial(this.callBack),
      appBar: generateAppBar(context),
      body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: <Widget>[ListCards(cardStorage: selectedStorage)],
          )),
    );
  }
}

class ListCards extends StatefulWidget {
  final String cardStorage;
  const ListCards({Key? key, required this.cardStorage}) : super(key: key);

  @override
  State<ListCards> createState() => _MyAppState();
}

class _MyAppState extends State<ListCards> {
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
                if (widget.cardStorage == data![index].userId.toString()) {
                  return GenerateCardWithInkWell.withoutArguments(
                    index: index,
                    data: data,
                    icon: Icons.credit_card,
                    route: "/stats",
                    view: 1,
                  );
                } else if (widget.cardStorage == "All") {
                  return GenerateCardWithInkWell.withoutArguments(
                    index: index,
                    data: data,
                    icon: Icons.credit_card,
                    route: "/stats",
                    view: 1,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: Container(
                child: Column(
          children: [generateProgressIndicator(context)],
        )));
      },
    ));
  }
}
