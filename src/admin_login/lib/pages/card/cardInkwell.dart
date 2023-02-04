import 'package:flutter/material.dart';
import 'package:admin_login/provider/types/cards.dart';
import 'package:admin_login/pages/widget/createCard.dart';

class GenerateCard extends StatefulWidget {
  final int index;
  final List<dynamic>? data;
  final IconData icon;
  final String route;
  final String argument;
  final int view;

  const GenerateCard({
    Key? key,
    required this.index,
    required this.data,
    required this.icon,
    required this.route,
    required this.view,
    this.argument = "",
  }) : super(key: key);

  @override
  State<GenerateCard> createState() => _GenerateCardState();
}

class _GenerateCardState extends State<GenerateCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
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
                      child: Icon(widget.icon, size: 50),
                    ),
                    Expanded(
                        child: createCardTable(
                      context,
                      widget.data![widget.index].name,
                      widget.data![widget.index].accessed,
                      widget.data![widget.index].available,
                    )),
                  ])),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Text(
                            'Karte bearbeiten',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          content: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Sie könnnen folgende Änderungen an der Karte vornehmen:",
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
                                          "Karte bearbeiten",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).focusColor),
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
                                          deleteData(
                                              widget.data![widget.index].name);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Karte löschen",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).focusColor),
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
                                            color:
                                                Theme.of(context).focusColor),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(double.infinity, 35),
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
            )));
  }
}
