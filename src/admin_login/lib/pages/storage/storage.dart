import 'package:admin_login/pages/storage/storageInkwell.dart';
import 'package:admin_login/pages/widget/reloadbutton.dart';
import 'package:admin_login/provider/types/focus.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/provider/types/storages.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/appbar.dart';

class StorageView extends StatefulWidget {
  StorageView({Key? key}) : super(key: key);

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  late List<Storages> listOfCards = [];
  List<Storages> persons = [];
  List<Storages> original = [];
  TextEditingController txtQuery = new TextEditingController();
  List<FocusS> listOfStorages = [];

  void loadData() async {
    await fetchData().then((value) => listOfCards = value);

    await getAllUnfocusedStorages().then((value) => listOfStorages = value);

    persons = listOfCards;
    original = listOfCards;
    setState(() {});
  }

  void search(String query) {
    if (query.isEmpty) {
      persons = original;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    List<Storages> result = [];
    for (int i = 0; i < persons.length; i++) {
      var name = persons[i].name.toString().toLowerCase();
      if (name.contains(query)) {
        result.add(persons[i]);
      }
    }

    persons = result;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  void reload() {
    setState(() {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      floatingActionButton: GenerateReloadButton(this.reload),
      body: Container(
          padding: EdgeInsets.all(5),
          child: Column(children: [
            Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          generateButtonRound(
                              context, "Hinzufügen", Icons.add, "/addStorage"),
                        ],
                      ),
                      SizedBox(
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
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
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
                child: Container(
              child: Column(children: [
                ListCardStorages(
                  storages: persons,
                  focus: listOfStorages,
                )
              ]),
            )),
          ])),
    );
  }
}

// ignore: must_be_immutable
class ListCardStorages extends StatefulWidget {
  List<Storages> storages;
  List<FocusS> focus;

  ListCardStorages({
    required this.storages,
    required this.focus,
    Key? key,
  }) : super(key: key);

  @override
  State<ListCardStorages> createState() => _ListCardStoragesState();
}

class _ListCardStoragesState extends State<ListCardStorages> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: widget.storages.length,
            itemBuilder: (BuildContext context, int index) {
              Color c = Colors.green;

              for (int i = 0; i < widget.focus.length; i++) {
                if (widget.focus[i].name == widget.storages[index].name) {
                  c = Colors.red;
                }
              }

              return GenerateStorage(
                index: index,
                data: widget.storages,
                icon: Icons.storage,
                route: "/alterStorage",
                argument: widget.storages[index].name,
                c: c,
              );
            }));
  }
}
