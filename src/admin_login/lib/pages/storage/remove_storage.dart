import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/searchfield.dart';
import 'package:admin_login/pages/widget/reloadbutton.dart';
import 'package:admin_login/pages/widget/cardwithoutinkwell.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: The Api needs to be changed in the future

List<int> searchValues = [];
List<int> selectedEntrys = [];

class RemoveStorage extends StatefulWidget {
  RemoveStorage({Key? key}) : super(key: key);

  @override
  State<RemoveStorage> createState() => _RemoveStorageState();
}

class _RemoveStorageState extends State<RemoveStorage> {
  void setSelectedEntrys(int data) {
    setState(() {
      selectedEntrys.add(data);
    });
  }

  void clearView() {
    setState(() {
      selectedEntrys = [];
    });
  }

  void setValues(int value) {
    searchValues.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Storage entfernen",
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: GenerateReloadButton(this.clearView)),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
              child: Row(
                children: [
                  generateSearchButton(
                    context,
                    "Suchen",
                    Icons.search,
                    this.setSelectedEntrys,
                    searchValues,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  generateButtonRoundWithoutRoute(
                    context,
                    "Entfernen",
                    Icons.remove,
                    searchValues,
                    () {
                      deleteData("storages", searchValues);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(children: [
                GenerateSearchValues(setValue: this.setValues),
                GenerateCards(),
              ]),
            ))
          ]),
        ));
  }
}

class GenerateCards extends StatefulWidget {
  const GenerateCards({Key? key}) : super(key: key);

  @override
  State<GenerateCards> createState() => _GenerateCardsState();
}

class _GenerateCardsState extends State<GenerateCards> {
  late Future<List<Storages>> futureData;

  @override
  void initState() {
    super.initState();
    reloadCardList();
  }

  void reloadCardList() {
    setState(() {
      futureData = fetchData("storages") as Future<List<Storages>>;
    });
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
                for (int i = 0; i < selectedEntrys.length; i++) {
                  if (data![index].id == selectedEntrys.elementAt(i)) {
                    return GenerateCardWithoutInkWell(
                      index: index,
                      data: data,
                      icon: Icons.credit_card,
                    );
                  }
                }
                return SizedBox.shrink();
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
            child: Column(
          children: [generateProgressIndicator(context)],
        ));
      },
    ));
  }
}
