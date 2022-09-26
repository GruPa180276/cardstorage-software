import 'package:flutter/material.dart';

import 'package:admin_login/pages/Widget/appbar.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      body: SingleChildScrollView(
          child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                //maximum width set to 100% of width
              ),
              padding: EdgeInsets.all(10),
              child: Row(children: [
                createWelcomePage(context),
              ]))),
    );
  }

  Widget createWelcomePage(BuildContext context) {
    return Expanded(
        child: Container(
      child: Column(children: [
        Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                  "Im Statistik Tab können Sie Statistiken anzeigen lassen oder exportieren.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  )),
            )),
        Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                  "Im Karten Tab können Sie neue Karten hinzufügen, löschen oder bearbeiten.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  )),
            )),
        Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                  "Im Storage Tab können Sie neue Kartentresore hinzufügen, löschen oder berbeiten.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  )),
            )),
        Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                  "Im Storage Tab können Sie neue Kartentresore hinzufügen, löschen oder berbeiten.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  )),
            )),
        Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                  "Im Benutzer Tab können Sie neue Benutzer hinzufügen, löschen oder berbeiten.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  )),
            )),
        Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                  "Im Mehr Tab können Sie sich Logs und vieles mehr ansehen",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  )),
            )),
      ]),
    ));
  }
}
