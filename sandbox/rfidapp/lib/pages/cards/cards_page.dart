import 'package:flutter/material.dart';
import 'package:rfidapp/pages/login/login_page.dart';
import 'package:rfidapp/pages/Navigation/menu_navigation.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPage();
}

class _CardPage extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuNavigationDrawer(),
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Cards",
            )),
        body: buildGetback(this.context));
  }

  Widget buildGetback(BuildContext context) {
    return SizedBox(
        width: 500,
        height: 60,
        child: OutlinedButton.icon(
          icon: Icon(
            Icons.create,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            "Zurück",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              width: 2.5,
              color: Theme.of(context).primaryColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ));
  }
}
