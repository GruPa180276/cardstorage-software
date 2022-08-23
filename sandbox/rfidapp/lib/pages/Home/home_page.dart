import 'package:flutter/material.dart';
import 'package:rfidapp/pages/Navigation/menu_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuNavigationDrawer(),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            title: const Text(
              "Homepage",
            )),
        body: buildGetback(this.context));
  }

  Widget buildGetback(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Table(
          children: [
            TableRow(
              children: [
                TableCell(child: Text("ID:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("Name:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("StorageId:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("Verfuegbar:")),
                TableCell(child: Text("ID:")),
              ],
            )
          ],
        ));
  }
}


// white, black, primary:, secondary: 