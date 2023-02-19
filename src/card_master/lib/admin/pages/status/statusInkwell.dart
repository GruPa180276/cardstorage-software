import 'dart:convert';

import 'package:card_master/admin/pages/widget/createStatus.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/provider/types/ping.dart';
import 'package:flutter/material.dart';
import 'package:card_master/admin/provider/types/storages.dart';

class GenerateStatus extends StatefulWidget {
  final int index;
  final List<dynamic>? data;
  final IconData icon;
  final String route;
  final String argument;

  const GenerateStatus({
    Key? key,
    required this.index,
    required this.data,
    required this.icon,
    required this.route,
    required this.argument,
  }) : super(key: key);

  @override
  State<GenerateStatus> createState() => _GenerateCardState();
}

class _GenerateCardState extends State<GenerateStatus> {
  late Ping ping;
  late Storages storage;
  int count = 0;
  bool pingWorked = false;
  bool focus = true;

  @override
  void initState() {
    super.initState();
    getNumberOfCardsInStorage();
    pingNow();
  }

  void pingNow() async {
    var response = await Data.checkAuthorization(
        context: context,
        function: pingStorage,
        args: {"name": widget.data![widget.index].name, 'data': []});
    dynamic jsonResponse = json.decode(response!.body);
    ping = Ping.fromJson(jsonResponse);

    if (ping.time != 0) {
      pingWorked = true;
    }
  }

  void getNumberOfCardsInStorage() async {
    var response = await Data.checkAuthorization(
        context: context,
        function: getAllCardsPerStorage,
        args: {"name": widget.data![widget.index].name, 'data': []});
    var temp = jsonDecode(response!.body);
    storage = Storages.fromJson(temp);

    count = 0;

    setState(() {
      for (int i = 0; i < storage.cards.length; i++) {
        if (storage.cards[i].available == true) {
          count++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;

    if (pingWorked == false) {
      color = Colors.red;
    }

    return SingleChildScrollView(
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        right: BorderSide(
                          color: color,
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
                          child: Icon(widget.icon, size: 50),
                        ),
                        Expanded(
                            child: createStatus(
                          context,
                          pingWorked,
                          widget.data![widget.index].name,
                          count,
                          widget.data![widget.index].numberOfCards,
                        )),
                      ])),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: Text(
                                'Storage anzeigen',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              content: new Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Sie könnnen folgende Aktionen an einem Storage vornehmen:",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await Data.checkAuthorization(
                                                  context: context,
                                                  function: focusStorage,
                                                  args: {
                                                    "name": widget
                                                        .data![widget.index]
                                                        .name,
                                                    'data': []
                                                  });
                                            },
                                            child: Text(
                                              "Focus",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .focusColor),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          ElevatedButton(
                                            onPressed: () async {
                                              pingNow();

                                              if (ping.time > 0) {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                              title: Text(
                                                                'Erfolgreich',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                              ),
                                                              content:
                                                                  new Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Storage wurde gepinged!",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: <Widget>[
                                                                Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    height: 70,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                            children: [
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
                                              if (ping.time == 0) {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                              title: Text(
                                                                'Ping Storage',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                              ),
                                                              content:
                                                                  new Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Es ist ein Fehler aufgetreten!",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: <Widget>[
                                                                Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    height: 70,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                            children: [
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
                                            },
                                            child: Text(
                                              "Ping",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .focusColor),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                "/status",
                                                arguments: widget
                                                    .data![widget.index].name,
                                              );
                                            },
                                            child: Text(
                                              "Statistik",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .focusColor),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Finish",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .focusColor),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                Size(double.infinity, 35),
                                            backgroundColor: Theme.of(context)
                                                .secondaryHeaderColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ));
                  },
                ))));
  }
}
