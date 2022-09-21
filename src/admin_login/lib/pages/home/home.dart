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
              padding: EdgeInsets.all(10),
              child: Column(children: [
                createWelcomePage(context),
              ]))),
    );
  }

  Widget createWelcomePage(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        Text("Willkommen im Admin Login",
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
            )),
        Divider(
          color: Theme.of(context).secondaryHeaderColor,
          height: 10,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(children: [
            Text(
                "- Im Statistik Tab können Sie Statistiken anzeigen lassen oder exportieren.\n\n"
                "- Im Karten Tab können Sie neue Karten hinzufügen, löschen oder bearbeiten.\n\n"
                "- Im Storage Tab können Sie neue Kartentresore hinzufügen, löschen oder berbeiten.\n\n"
                "- Im Storage Tab können Sie neue Kartentresore hinzufügen, löschen oder berbeiten.\n\n"
                "- Im Benutzer Tab können Sie neue Benutzer hinzufügen, löschen oder berbeiten.\n\n"
                "- Im Mehr Tab können Sie sich Logs und vieles mehr ansehen\n\n"
                "Aktuelle Version: v0.5.0 Beta",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ))
          ]),
        )
      ]),
    );
  }
}
