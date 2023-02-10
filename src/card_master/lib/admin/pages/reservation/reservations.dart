import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/time.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/listTile.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';
import 'package:card_master/admin/provider/types/reservations.dart';
import 'package:card_master/admin/provider/types/cardReservation.dart';
import 'package:card_master/admin/pages/widget/createReservationTable.dart';
import 'package:card_master/admin/provider/types/cardReservation.dart'
    as cardReservation;

class Reservations extends StatefulWidget {
  const Reservations({Key? key}) : super(key: key);

  @override
  State<Reservations> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Reservations> {
  late ReservationTime resTime = new ReservationTime(time: 0, unit: "hours");
  double time = 0;

  void setTime(String time) {
    this.time = double.parse(time);
  }

  late List<CardReservation> listOfCards = [];
  List<CardReservation> persons = [];
  List<CardReservation> original = [];
  TextEditingController txtQuery = new TextEditingController();

  void loadData() async {
    await cardReservation.fetchData().then((value) => listOfCards = value);

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
    List<CardReservation> result = [];
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
        floatingActionButton: GenerateReloadButton(this.reload),
        appBar: AppBar(
            title: Text(
              "Reservierungen",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(children: [
                                Expanded(
                                    child: GenerateListTile(
                                  labelText: "Zeit",
                                  hintText: "",
                                  icon: Icons.description,
                                  regExp: r'([0-9\. ])',
                                  function: this.setTime,
                                  controller: new TextEditingController(),
                                  fun: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter valid name';
                                    }
                                    return null;
                                  },
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                generateButtonRectangle(
                                  context,
                                  "Speichern",
                                  () {
                                    changeReservationLatestGetTime(time);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ]),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: txtQuery,
                                onChanged: search,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  prefixIcon: Icon(Icons.search),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      txtQuery.text = '';
                                      search(txtQuery.text);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))),
            _listView(persons)
          ]),
        ));
  }

  Widget _listView(List<CardReservation> persons) {
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: persons.length,
            itemBuilder: (BuildContext context, int index) {
              List<ReservationOfCards> data = persons[index].reservation;
              cardReservation.CardReservation c = persons[index];
              return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Color col = Colors.green;
                    if (data[index].until * 1000 <
                        DateTime.now().millisecondsSinceEpoch) {
                      col = Colors.red;
                    }

                    return Container(
                      child: Column(children: [
                        Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: InkWell(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                        right: BorderSide(
                                          color: col,
                                          width: 10,
                                        ),
                                      )),
                                      padding: EdgeInsets.all(15),
                                      child: Row(children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 0,
                                            right: 15,
                                          ),
                                          child: Icon(Icons.bookmark, size: 50),
                                        ),
                                        Expanded(
                                            child: createReservationTable(
                                          context,
                                          c.name,
                                          data[index].users.email,
                                          data[index].since,
                                          data[index].until,
                                          data[index].returnedAt,
                                        )),
                                      ])),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder:
                                            (BuildContext context) =>
                                                AlertDialog(
                                                  backgroundColor: Theme.of(
                                                          context)
                                                      .scaffoldBackgroundColor,
                                                  title: Text(
                                                    'Reservierung löschen',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  content: new Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Wollen Sie diese Reservierung löschen?",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        height: 70,
                                                        child: Column(
                                                          children: [
                                                            Row(children: [
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Future<int>
                                                                      code =
                                                                      deleteReservation(
                                                                          data[index]
                                                                              .id);

                                                                  if (await code ==
                                                                      200) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext
                                                                                context) =>
                                                                            AlertDialog(
                                                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                                              title: Text(
                                                                                'Reservierung löschen',
                                                                                style: TextStyle(color: Theme.of(context).primaryColor),
                                                                              ),
                                                                              content: new Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Reservierung gelöscht",
                                                                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              actions: <Widget>[
                                                                                Container(
                                                                                    padding: EdgeInsets.all(10),
                                                                                    height: 70,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Row(children: [
                                                                                          ElevatedButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: Text(
                                                                                              "Finish",
                                                                                              style: TextStyle(color: Theme.of(context).focusColor),
                                                                                            ),
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ]),
                                                                                      ],
                                                                                    )),
                                                                              ],
                                                                            ));
                                                                  }
                                                                  if (await code ==
                                                                      400) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext
                                                                                context) =>
                                                                            AlertDialog(
                                                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                                              title: Text(
                                                                                'Reservierung löschen',
                                                                                style: TextStyle(color: Theme.of(context).primaryColor),
                                                                              ),
                                                                              content: new Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Es ist ein Fehler aufgetreten!",
                                                                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              actions: <Widget>[
                                                                                Container(
                                                                                    padding: EdgeInsets.all(10),
                                                                                    height: 70,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Row(children: [
                                                                                          ElevatedButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: Text(
                                                                                              "Finish",
                                                                                              style: TextStyle(color: Theme.of(context).focusColor),
                                                                                            ),
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ]),
                                                                                      ],
                                                                                    )),
                                                                              ],
                                                                            ));
                                                                  }
                                                                  ;
                                                                },
                                                                child: Text(
                                                                  "Ja",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .focusColor),
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Theme.of(
                                                                              context)
                                                                          .secondaryHeaderColor,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  "Nein",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .focusColor),
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Theme.of(
                                                                              context)
                                                                          .secondaryHeaderColor,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                              )
                                                            ]),
                                                          ],
                                                        )),
                                                  ],
                                                ));
                                  },
                                )))
                      ]),
                    );
                  });
            }));
  }
}
