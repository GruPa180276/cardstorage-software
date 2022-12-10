import 'package:flutter/material.dart';

class StatusStorage extends StatefulWidget {
  StatusStorage({Key? key}) : super(key: key);

  @override
  State<StatusStorage> createState() => _StatusStorageState();
}

class _StatusStorageState extends State<StatusStorage> {
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
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Text(
              "Letzter Ping",
            ),
            Text(
              "Ping Storage",
            ),
            Text(
              "Errors",
            ),
            Text(
              "Karten über der Zeit",
            ),
            Text(
              "Wer hat die Karte",
            ),
            Text(
              "Statistik, wie oft die Karten augeborgt wurden",
            )
          ]),
        ));
  }
}
