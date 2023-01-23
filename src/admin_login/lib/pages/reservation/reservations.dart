import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/createReservationTable.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/provider/types/cardReservation.dart'
    as cardReservation;
import 'package:admin_login/provider/types/cardReservation.dart';
import 'package:admin_login/provider/types/reservations.dart';
import 'package:admin_login/provider/types/time.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/reloadbutton.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

class Reservations extends StatefulWidget {
  const Reservations({Key? key}) : super(key: key);

  @override
  State<Reservations> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Reservations> {
  late Future<List<CardReservation>> futureData;
  late ReservationTime resTime = new ReservationTime(time: 0, unit: "hours");
  double time = 0;

  @override
  void initState() {
    super.initState();
    loadData();
    futureData = cardReservation.fetchData();
  }

  void loadData() async {
    await getReservationLatestGetTime().then((value) => resTime = value);

    setState(() {});
  }

  void reload() {
    setState(() {
      futureData = cardReservation.fetchData();
    });
  }

  void setTime(String time) {
    this.time = double.parse(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GenerateReloadButton(this.reload),
      appBar: AppBar(
          title: Text(
            "Reservierungen",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          actions: []),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(children: [
          GenerateListTile(
            labelText: "Name",
            hintText: resTime.time.toString(),
            icon: Icons.description,
            regExp: r'([0-9\. ])',
            function: this.setTime,
          ),
          Container(
            height: 80,
            child: Column(children: [
              generateButtonRectangle(
                context,
                "Änderungen speichern",
                () {
                  changeReservationLatestGetTime(time);
                  Navigator.of(context).pop();
                },
              ),
            ]),
          ),
          ListCards(
            cards: futureData,
          )
        ]),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListCards extends StatefulWidget {
  Future<List<CardReservation>> cards;

  ListCards({
    Key? key,
    required this.cards,
  }) : super(key: key);

  @override
  State<ListCards> createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<CardReservation>>(
        future: widget.cards,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  List<ReservationOfCards> data =
                      snapshot.data![index].reservation;
                  cardReservation.CardReservation c = snapshot.data![index];
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              child: Container(
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
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          title: Text(
                                            'Reservierung löschen',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          content: new Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Wollen Sie diese Reservierung löschen?",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
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
                                                          Navigator.of(context)
                                                              .pop();

                                                          deleteReservation(
                                                              data[index].id);
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
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .secondaryHeaderColor,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
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
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .secondaryHeaderColor,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                                  ],
                                                )),
                                          ],
                                        ));
                              },
                            ));
                      });
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Container(
              child: Column(
            children: [generateProgressIndicator(context)],
          ));
        },
      ),
    );
  }
}
