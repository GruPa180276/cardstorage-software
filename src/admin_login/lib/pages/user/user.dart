import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/appbar.dart';
import 'package:admin_login/pages/widget/searchfield.dart';
import 'package:admin_login/pages/widget/clearbutton.dart';
import 'package:admin_login/pages/widget/cardwithinkwell.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

List<String> searchValues = [];
List<String> selectedEntrys = [];

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  void setID(String data) {
    setState(() {
      selectedEntrys.add(data);
    });
  }

  void clear() {
    setState(() {
      selectedEntrys = [];
    });
  }

  void setSelectedEntrys(String data) {
    setState(() {
      selectedEntrys.add(data);
    });
  }

  void clearView() {
    setState(() {
      selectedEntrys = [];
    });
  }

  void setValues(String value) {
    searchValues.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: generateReloadButton(context, clear)),
            ),
          ],
        ),
        appBar: generateAppBar(context),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
                child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  generateButtonRound(
                      context, "Hinzufügen", Icons.add, "/addUser"),
                  SizedBox(
                    width: 10,
                  ),
                  generateButtonRound(
                      context, "Entfernen", Icons.remove, "/removeUser"),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  generateSearchButton(
                    context,
                    "Suchen",
                    Icons.search,
                    this.setSelectedEntrys,
                    searchValues,
                  ),
                ],
              )
            ])),
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
  late Future<List<Data>> futureData;

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
        child: FutureBuilder<List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data>? data = snapshot.data;
                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (selectedEntrys.length == 0) {
                        return GenerateCardWithInkWell.withArguments(
                            index: index,
                            data: data,
                            icon: Icons.credit_card,
                            route: "/alterUser",
                            argument: data![index].id - 1);
                      } else {
                        for (int i = 0; i < selectedEntrys.length; i++) {
                          if (data![index].title ==
                              selectedEntrys.elementAt(i)) {
                            return GenerateCardWithInkWell.withArguments(
                                index: index,
                                data: data,
                                icon: Icons.credit_card,
                                route: "/alterUser",
                                argument: data[index].id - 1);
                          }
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
            }));
  }
}
