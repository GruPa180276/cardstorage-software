import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/provider/types/ping.dart';
import 'package:admin_login/provider/types/storages.dart';

class StatusStorage extends StatefulWidget {
  final String name;

  StatusStorage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<StatusStorage> createState() => _StatusStorageState();
}

class _StatusStorageState extends State<StatusStorage> {
  List<int> pingValues = [];
  Ping? ping;

  @override
  void initState() {
    super.initState();
  }

  void pingNow() async {
    await pingStorage(widget.name).then((value) => ping = value);

    print(ping?.name);
    print(ping?.time);
  }

  void focus() {
    focusStorage(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Status Storage",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: Container(
          height: 150,
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            generateButtonWithDialog(
              context,
              "Storage pingen",
              (() {
                pingNow();
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Text(
                            'Storage wird gepinged ...',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          content: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Der Storage " +
                                    ping!.name +
                                    " wird gepinged ... \n\n" +
                                    "Benötigte Zeit: " +
                                    ping!.time.toString(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 70,
                              child: Column(children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Beenden",
                                    style: TextStyle(
                                        color: Theme.of(context).focusColor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ));
              }),
            ),
            generateButtonWithDialog(
              context,
              "Focus Storage",
              (() {
                focus();
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Text(
                            'Karte hinzufügen',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          content: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Der Storage " +
                                    widget.name +
                                    "wird ins System augneommen ...",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 70,
                              child: Column(children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Abschließen",
                                    style: TextStyle(
                                        color: Theme.of(context).focusColor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ));
              }),
            )
          ]),
        ));
  }
}
