import 'package:flutter/material.dart';

import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/searchfieldStorages.dart';
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
  void setSelectedEntrys(int value) {
    setState(() {
      searchValues = [];
      selectedEntrys.add(value);
    });
  }

  void clearView() {
    setState(() {
      selectedEntrys = [];
      searchValues = [];
    });
  }

  void setValues(int value) {
    bool x = searchValues.contains(value);

    if (x == false) {
      searchValues.add(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Storages entfernen",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      GenerateSearchValues(setValue: this.setValues),
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
                          for (int i = 0; i < searchValues.length; i++) {
                            deleteData(searchValues[i]);
                          }
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
                    GenerateCards(),
                  ]),
                ))
              ],
            )));
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
      futureData = fetchData();
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
