import 'package:flutter/material.dart';
import 'package:rfidapp/pages/Navigation/menu_navigation.dart';

class ReservatePage extends StatefulWidget {
  ReservatePage({Key? key}) : super(key: key);

  @override
  State<ReservatePage> createState() => _ReservatePageState();
}

class _ReservatePageState extends State<ReservatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuNavigationDrawer(),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            title: const Text(
              "Reservierungen",
            )),
        body: Text('hello world'));
  }
}
