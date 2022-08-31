import 'package:flutter/material.dart';

import 'package:app/config/text_values/home_text_values.dart';

HomeTextValues homeTextValues = new HomeTextValues();

void main() => runApp(Menu());

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key) {}

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.credit_card,
          size: 30,
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.blueGrey,
        title: Text('Admin Login',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        actions: [
          Icon(Icons.account_box_rounded),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.settings),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.logout),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(padding: EdgeInsets.all(10), child: Column(children: [])),
    );
  }
}
