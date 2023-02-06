import 'package:admin_login/pages/widget/createStatus.dart';
import 'package:admin_login/pages/widget/createStorage.dart';
import 'package:admin_login/provider/types/ping.dart';
import 'package:flutter/material.dart';
import 'package:admin_login/provider/types/storages.dart';

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
    pingNow();
    getNumberOfCardsInStorage();
  }

  void pingNow() async {
    await pingStorage(widget.data![widget.index].name)
        .then((value) => ping = value);

    if (ping.time != 0) {
      pingWorked = true;
    }
  }

  void getNumberOfCardsInStorage() async {
    await getAllCardsPerStorage(widget.data![widget.index].name)
        .then((value) => storage = value);

    count = 0;

    setState(() {
      for (int i = 0; i < storage.cards.length; i++) {
        if (storage.cards[i].available == true) {
          count++;
        }
      }
    });
  }

  void pingNowNow() async {
    await pingStorage(widget.data![widget.index].name)
        .then((value) => ping = value);

    setState(() {});
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
                                    "Sie könnnen folgende Änderungen an dem Storage vornehmen:",
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
                                            onPressed: () {
                                              focusStorage(
                                                widget.data![widget.index].name,
                                              );
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
                                            onPressed: () {
                                              pingNow();
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
