import 'package:card_master/admin/pages/widget/createStorage.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/user.dart';
import 'package:flutter/material.dart';
import 'package:card_master/admin/provider/types/storages.dart';

class GenerateStorage extends StatefulWidget {
  final int index;
  final List<dynamic>? data;
  final IconData icon;
  final String route;
  final String argument;
  final bool focus;

  final Color c;

  const GenerateStorage(
      {Key? key,
      required this.index,
      required this.data,
      required this.icon,
      required this.route,
      required this.argument,
      required this.c,
      required this.focus})
      : super(key: key);

  @override
  State<GenerateStorage> createState() => _GenerateCardState();
}

class _GenerateCardState extends State<GenerateStorage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          color: widget.c,
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
                            child: createStorageTable(
                                context,
                                widget.data![widget.index].name,
                                widget.data![widget.index].location,
                                widget.data![widget.index].numberOfCards,
                                widget.focus)),
                      ])),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: Text(
                                'Storage bearbeiten',
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
                                              Navigator.of(context).pushNamed(
                                                  widget.route,
                                                  arguments: widget.argument);
                                            },
                                            child: Text(
                                              "Storage bearbeiten",
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
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            backgroundColor: Theme
                                                                    .of(context)
                                                                .scaffoldBackgroundColor,
                                                            title: Text(
                                                              'Storage löschen',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                            content: new Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Wollen Sie diesen Storage löschen?",
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
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  height: 70,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                          children: [
                                                                            ElevatedButton(
                                                                              onPressed: () async {
                                                                                await Data.checkAuthorization(
                                                                                  context: context,
                                                                                  function: deleteStorage,
                                                                                  args: {
                                                                                    "name": widget.data![widget.index].name,
                                                                                    'data': []
                                                                                  },
                                                                                );

                                                                                await Data.checkAuthorization(
                                                                                  context: context,
                                                                                  function: deleteUser,
                                                                                  args: {
                                                                                    "name": widget.data![widget.index].name.toString().toLowerCase() + "@default.com",
                                                                                    'data': []
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: Text(
                                                                                "Ja",
                                                                                style: TextStyle(color: Theme.of(context).focusColor),
                                                                              ),
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text(
                                                                                "Nein",
                                                                                style: TextStyle(color: Theme.of(context).focusColor),
                                                                              ),
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                    ],
                                                                  )),
                                                            ],
                                                          ));
                                            },
                                            child: Text(
                                              "Storage löschen",
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
                                          )
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
