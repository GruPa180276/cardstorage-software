import 'package:flutter/material.dart';

import 'package:app/config/values/home_text_values.dart';

import 'package:app/pages/Widget/appbar.dart';

HomeTextValues homeTextValues = new HomeTextValues();

void main() => runApp(Home());

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key) {}

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [createWelcomePage(context)])),
    );
  }

  Widget createWelcomePage(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        Text(homeTextValues.getWelcomePageHeadline(),
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
        Expanded(
            child: ListView(
          children: <Widget>[
            Text(homeTextValues.getWelcomePageText(),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        )),
      ]),
    ));
  }
}
